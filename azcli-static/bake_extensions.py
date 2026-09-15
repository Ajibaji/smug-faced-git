#!/usr/bin/env python3
"""Download Azure CLI extension wheels and stage them for baking into the build.

`az extension add` normally pulls wheels from the Azure extension index (not
PyPI - the PyPI package named e.g. `azure-devops` is the SDK, not the CLI
extension) and installs them with `pip install --target`. This reproduces that
at build time so the resulting binary ships with the extensions already present
and works on a machine with no network.

The frozen binary can still install extensions at runtime, because az_entry.py
implements `az.exe -m pip ...` and pip is bundled - but pre-baking avoids the
first-use download entirely.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path

INDEX_URL = "https://aka.ms/azure-cli-extension-index-v1"


def parse_version(v: str) -> tuple:
    parts = []
    for chunk in v.replace("-", ".").split("."):
        parts.append((0, int(chunk)) if chunk.isdigit() else (1, 0))
    return tuple(parts)


def fetch_index() -> dict:
    print(f"fetching extension index: {INDEX_URL}")
    with urllib.request.urlopen(INDEX_URL, timeout=60) as resp:
        return json.load(resp)


def pick(index: dict, name: str) -> dict:
    exts = index.get("extensions", {})
    if name not in exts:
        close = [k for k in exts if name in k]
        hint = f" Did you mean: {', '.join(sorted(close)[:5])}?" if close else ""
        sys.exit(f"error: extension '{name}' not in index.{hint}")
    candidates = exts[name]
    best = max(candidates, key=lambda c: parse_version(c["metadata"]["version"]))
    return best


def bake(names: list[str], dest: Path, python: str) -> None:
    dest.mkdir(parents=True, exist_ok=True)
    index = fetch_index()

    with tempfile.TemporaryDirectory() as tmp:
        wheels = []
        for name in names:
            entry = pick(index, name)
            url = entry["downloadUrl"]
            version = entry["metadata"]["version"]
            whl = Path(tmp) / url.rsplit("/", 1)[-1]
            print(f"  {name} {version} -> {whl.name}")
            urllib.request.urlretrieve(url, whl)
            wheels.append(str(whl))

        # Mirrors azure.cli.core.extension.operations._run_pip
        cmd = [python, "-m", "pip", "install", "--target", str(dest),
               "--disable-pip-version-check", "--no-cache-dir", *wheels]
        print("  " + " ".join(cmd[:6]) + " ...")
        subprocess.run(cmd, check=True)

    baked = sorted(p.name for p in dest.glob("azext_*") if p.is_dir())
    total = sum(f.stat().st_size for f in dest.rglob("*") if f.is_file())
    print(f"staged {len(baked)} extension(s) in {dest} ({total / 1e6:.1f} MB): {', '.join(baked)}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("names", nargs="+", help="extension names, e.g. azure-devops")
    ap.add_argument("--dest", type=Path, required=True, help="staging dir")
    ap.add_argument("--python", default=sys.executable, help="interpreter whose pip to use")
    args = ap.parse_args()
    bake(args.names, args.dest.resolve(), args.python)


if __name__ == "__main__":
    main()
