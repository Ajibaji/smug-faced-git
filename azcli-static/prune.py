#!/usr/bin/env python3
"""Prune dead weight from a site-packages tree that has azure-cli installed.

This runs BEFORE PyInstaller so that the module-graph scan physically cannot
pick up the things we delete (collect_submodules walks the filesystem).

Measured on azure-cli 2.88.0:

    azure/**/aio/   128.7 MB   async SDK clients - azure-cli is 100% sync,
                               grep for `.aio` under azure/cli returns 0 hits.
    tests/            2.6 MB
    *.pyi, py.typed   1.8 MB
    *.dist-info       8.6 MB   safe since azure-cli 2.5x: get_installed_cli_
                               distributions() no longer uses pkg_resources,
                               it reads hard-coded __version__ attributes.

Deliberately NOT pruned: azure/mgmt/**/vYYYY_MM_DD/ API-version folders.
Measured saving is only ~16 MB of 133 MB (the CLI really does reference 102 of
119 version dirs) and getting it wrong yields runtime ImportErrors on obscure
subcommands. Bad trade.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import sys
from pathlib import Path

VERSION_DIR = re.compile(r"^v\d{4}_\d{2}_\d{2}(_preview)?$")


def dir_size(path: Path) -> int:
    total = 0
    for root, _dirs, files in os.walk(path):
        for f in files:
            try:
                total += os.path.getsize(os.path.join(root, f))
            except OSError:
                pass
    return total


def mb(n: int) -> str:
    return f"{n / 1_000_000:8.1f} MB"


def prune(site: Path, dry_run: bool = False) -> None:
    if not site.is_dir():
        sys.exit(f"error: {site} is not a directory")

    azure = site / "azure"
    if not azure.is_dir():
        # Still worth running: this is also used on the staged extension dir,
        # which has no azure/ tree but does carry tests and stubs.
        print(f"note: no azure/ under {site}, pruning generic cruft only")

    freed = 0
    counts: dict[str, int] = {}

    def drop(path: Path, label: str) -> None:
        nonlocal freed
        size = dir_size(path) if path.is_dir() else path.stat().st_size
        freed += size
        counts[label] = counts.get(label, 0) + size
        if not dry_run:
            if path.is_dir():
                shutil.rmtree(path, ignore_errors=True)
            else:
                try:
                    path.unlink()
                except OSError:
                    pass

    # 1. async clients - the single biggest win
    for root, dirs, _files in os.walk(azure):
        for d in list(dirs):
            if d == "aio":
                dirs.remove(d)
                drop(Path(root) / d, "aio/ (async SDK clients)")

    # 2. bundled test suites
    for root, dirs, _files in os.walk(site):
        for d in list(dirs):
            if d in ("tests", "test", "testsuite"):
                dirs.remove(d)
                drop(Path(root) / d, "tests/")
            elif d == "__pycache__":
                dirs.remove(d)
                drop(Path(root) / d, "__pycache__/ (rebuilt by PyInstaller)")

    # 3. typing stubs - never read at runtime
    for pattern in ("*.pyi", "py.typed"):
        for p in site.rglob(pattern):
            drop(p, "typing stubs")

    # 4. packaging metadata. azure-cli reads __version__ attributes, not metadata.
    #    Keep anything an extension might introspect.
    keep_meta = ("azure_cli", "azure_cli_core", "azure_cli_telemetry")
    for p in site.glob("*.dist-info"):
        if not p.name.startswith(keep_meta):
            drop(p, "*.dist-info")
    for p in site.glob("*.egg-info"):
        drop(p, "*.egg-info")

    label_w = max((len(k) for k in counts), default=0)
    print(f"{'-' * (label_w + 14)}")
    for label, size in sorted(counts.items(), key=lambda kv: -kv[1]):
        print(f"{label:<{label_w}}  {mb(size)}")
    print(f"{'-' * (label_w + 14)}")
    print(f"{'TOTAL FREED':<{label_w}}  {mb(freed)}")
    if dry_run:
        print("\n(dry run - nothing deleted)")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("site_packages", type=Path,
                    help="path to the build venv's site-packages")
    ap.add_argument("-n", "--dry-run", action="store_true")
    args = ap.parse_args()
    prune(args.site_packages.resolve(), args.dry_run)


if __name__ == "__main__":
    main()
