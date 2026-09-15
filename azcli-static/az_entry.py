"""Frozen entry point for the Azure CLI.

azure/cli/__main__.py does all of its work at module import time (it builds the
CLI, invokes it, and calls sys.exit from a finally block), so it must be run as
__main__ rather than imported and called. runpy does exactly that.

This wrapper also emulates `python -m <module>`, which is what makes
`az extension add` work in a frozen build: azure.cli.core.extension.operations
shells out to

    [sys.executable, '-m', 'pip', 'install', '--target', ...]

and in a frozen build sys.executable is az.exe. By honouring `-m` and bundling
pip, that subprocess resolves to a real pip run inside our embedded interpreter,
so wheels are resolved against the correct Python version and ABI.
"""

import multiprocessing
import os
import runpy
import sys

_UPGRADE_MSG = """\
'az upgrade' cannot work in a standalone build - there is no pip-managed
install to upgrade. Replace the az.exe binary with a newer build instead.

Set AZ_STATIC_ALLOW_UPGRADE=1 to run it anyway (it will fail).
"""


def _run_module_mode(argv: list[str]) -> bool:
    """Handle `az.exe -m <module> [args...]`. Returns True if handled."""
    if len(argv) >= 2 and argv[0] == "-m":
        module = argv[1]
        sys.argv = [module, *argv[2:]]
        runpy.run_module(module, run_name="__main__", alter_sys=True)
        return True
    return False


def main() -> None:
    # Storage/batch commands spawn worker processes. Without this, a frozen
    # child re-runs the entire CLI instead of the worker bootstrap.
    multiprocessing.freeze_support()

    argv = sys.argv[1:]

    if _run_module_mode(argv):
        return

    if argv[:1] == ["upgrade"] and not os.environ.get("AZ_STATIC_ALLOW_UPGRADE"):
        sys.stderr.write(_UPGRADE_MSG)
        raise SystemExit(1)

    # knack and argcomplete read sys.argv[0] for usage strings and completion.
    sys.argv[0] = "az"

    runpy.run_module("azure.cli", run_name="__main__", alter_sys=True)


if __name__ == "__main__":
    main()
