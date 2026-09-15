# -*- mode: python ; coding: utf-8 -*-
"""PyInstaller spec for a standalone Azure CLI.

Driven by env vars set by build.ps1:

    AZSTATIC_ROOT     directory containing this spec
    AZSTATIC_MODE     'onedir' (default) or 'onefile'
    AZSTATIC_EXT_SRC  optional dir of pre-installed azext_* extensions to bake in

Run prune.py against the build venv FIRST. collect_submodules() walks the
filesystem, so anything already deleted (notably azure/**/aio/, 129 MB) simply
cannot enter the module graph. That ordering is what keeps this tractable.
"""

import os
from pathlib import Path

from PyInstaller.utils.hooks import collect_data_files, collect_submodules

ROOT = Path(os.environ.get("AZSTATIC_ROOT", os.getcwd())).resolve()
MODE = os.environ.get("AZSTATIC_MODE", "onedir").lower()
EXT_SRC = os.environ.get("AZSTATIC_EXT_SRC", "").strip()

# ---------------------------------------------------------------------------
# Hidden imports.
#
# azure-cli discovers command modules at runtime with
#   pkgutil.iter_modules(import_module('azure.cli.command_modules').__path__)
# and the SDK layer resolves azure.mgmt.* clients by string name from
# azure.cli.core.profiles. Neither is visible to static analysis, so every
# submodule has to be named explicitly.
# ---------------------------------------------------------------------------
_PACKAGES = [
    "azure.cli",
    "azure.cli.command_modules",
    "azure.cli.core",
    "azure.cli.telemetry",
    "azure.mgmt",
    "azure.core",
    "azure.identity",
    "azure.storage",
    "azure.keyvault",
    "azure.synapse",
    "azure.batch",
    "azure.appconfiguration",
    "azure.data",
    "azure.monitor",
    "azure.cosmos",
    "azure.datalake",
    "azure.ai",
    "azure.common",
    "azure.profiles",
    "azure.multiapi",
    "knack",
    "msal",
    "msal_extensions",
    "msrest",
    "msrestazure",
    "jmespath",
    "pygments.lexers",
    "pygments.formatters",
    # Bundled so that `az.exe -m pip ...` works -> `az extension add` works.
    "pip",
]

hiddenimports: list[str] = []
for pkg in _PACKAGES:
    try:
        found = collect_submodules(pkg)
        hiddenimports += found
        print(f"[az.spec] {pkg}: {len(found)} submodules")
    except Exception as exc:  # package legitimately absent in some versions
        print(f"[az.spec] skip {pkg}: {exc}")

# ---------------------------------------------------------------------------
# Data files: help YAML, ARM templates, JSON resource definitions, etc.
# ---------------------------------------------------------------------------
datas: list[tuple[str, str]] = []
for pkg in ("azure.cli", "azure.mgmt", "azure.core", "knack", "pip"):
    try:
        datas += collect_data_files(pkg, include_py_files=False)
    except Exception as exc:
        print(f"[az.spec] no data for {pkg}: {exc}")

# Bake in extensions pip-installed to a staging dir at build time.
if EXT_SRC:
    ext_root = Path(EXT_SRC).resolve()
    if ext_root.is_dir():
        n = 0
        for f in ext_root.rglob("*"):
            if f.is_file() and "__pycache__" not in f.parts:
                dest = Path("azext") / f.relative_to(ext_root).parent
                datas.append((str(f), str(dest)))
                n += 1
        print(f"[az.spec] baking in {n} extension files from {ext_root}")

# ---------------------------------------------------------------------------
# Exclusions. Nothing here is reachable from the CLI.
# ---------------------------------------------------------------------------
excludes = [
    "tkinter", "_tkinter", "turtle", "turtledemo",
    "test", "lib2to3", "pydoc_data", "idlelib", "ensurepip",
    "IPython", "pytest", "_pytest", "sphinx", "docutils",
    "matplotlib", "PIL", "numpy", "scipy", "pandas",
    "PyQt5", "PySide2", "notebook", "jupyter",
]

a = Analysis(
    [str(ROOT / "az_entry.py")],
    pathex=[],
    binaries=[],
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[str(ROOT / "rthook_az.py")],
    excludes=excludes,
    noarchive=False,
    # Note: PyInstaller's optimize=2 would strip docstrings for a worthwhile
    # size win, but several command modules surface __doc__ as help text.
    # Not worth the regression, so it is left at the default.
)

pyz = PYZ(a.pure)

if MODE == "onefile":
    exe = EXE(
        pyz,
        a.scripts,
        a.binaries,
        a.datas,
        [],
        name="az",
        debug=False,
        bootloader_ignore_signals=False,
        strip=False,
        upx=False,          # UPX on a 60 MB exe buys little and trips AV
        console=True,
        disable_windowed_traceback=False,
        argv_emulation=False,
        target_arch=None,
        codesign_identity=None,
        entitlements_file=None,
    )
else:
    exe = EXE(
        pyz,
        a.scripts,
        [],
        exclude_binaries=True,
        name="az",
        debug=False,
        bootloader_ignore_signals=False,
        strip=False,
        upx=False,
        console=True,
        disable_windowed_traceback=False,
        argv_emulation=False,
        target_arch=None,
        codesign_identity=None,
        entitlements_file=None,
    )
    coll = COLLECT(
        exe,
        a.binaries,
        a.datas,
        strip=False,
        upx=False,
        name="az",
    )
