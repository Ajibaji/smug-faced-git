#!/usr/bin/env python3
"""Pack a PyInstaller onedir output into a solid tar.xz for the Go launcher.

Why tar.xz and not zip/gzip: the Azure SDK is ~8,600 machine-generated .pyc
files that are highly redundant *across* files. deflate's 32 KB window cannot
see that; LZMA's multi-MB window can. Measured on azure-cli 2.88.0, 228 MB of
reachable bytecode:

    zlib -9    51.4 MB   ( 4.4x)   <- what a zip/PyInstaller PYZ gets
    lzma -6    15.0 MB   (15.2x)   <- what this produces

Packing uses only the Python stdlib (tarfile + lzma), so there is no extra
build-time dependency.
"""

from __future__ import annotations

import argparse
import hashlib
import io
import lzma
import os
import sys
import tarfile
import time
from pathlib import Path


def tree_fingerprint(src: Path) -> str:
    """Stable id for the payload, used as the extraction cache key."""
    h = hashlib.sha256()
    for path in sorted(src.rglob("*")):
        if path.is_file():
            h.update(str(path.relative_to(src)).replace(os.sep, "/").encode())
            h.update(str(path.stat().st_size).encode())
    return h.hexdigest()[:16]


def pack(src: Path, out: Path, preset: int) -> None:
    if not src.is_dir():
        sys.exit(f"error: {src} is not a directory")

    files = [p for p in sorted(src.rglob("*")) if p.is_file()]
    raw = sum(p.stat().st_size for p in files)
    print(f"packing {len(files):,} files / {raw / 1e6:.1f} MB from {src}")

    out.parent.mkdir(parents=True, exist_ok=True)
    start = time.time()

    # Single solid LZMA stream over the whole tar - cross-file redundancy is
    # exactly where the win comes from, so do not compress per-member.
    filters = [{"id": lzma.FILTER_LZMA2, "preset": preset}]
    with lzma.open(out, "wb", format=lzma.FORMAT_XZ, filters=filters) as xz:
        with tarfile.open(fileobj=xz, mode="w|") as tar:
            for p in files:
                info = tar.gettarinfo(str(p), arcname=str(p.relative_to(src)).replace(os.sep, "/"))
                # Deterministic output: identical input -> identical payload.
                info.mtime = 0
                info.uid = info.gid = 0
                info.uname = info.gname = ""
                with open(p, "rb") as fh:
                    tar.addfile(info, fh)

    packed = out.stat().st_size
    elapsed = time.time() - start
    ratio = raw / packed if packed else 0
    print(f"-> {out}  {packed / 1e6:.1f} MB  ({ratio:.1f}x, {elapsed:.0f}s)")

    fp = tree_fingerprint(src)
    (out.parent / "payload.id").write_text(fp, encoding="ascii")
    print(f"-> payload.id  {fp}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("src", type=Path, help="PyInstaller onedir output (dist/az)")
    ap.add_argument("out", type=Path, help="output path for payload.tar.xz")
    ap.add_argument("--preset", type=int, default=6,
                    help="LZMA preset 0-9 (default 6; 9 is ~2%% smaller, far slower)")
    args = ap.parse_args()
    pack(args.src.resolve(), args.out.resolve(), args.preset)


if __name__ == "__main__":
    main()
