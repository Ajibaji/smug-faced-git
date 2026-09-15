"""PyInstaller runtime hook - runs inside the frozen az.exe before any user code.

Fixes the four things that break when azure-cli is frozen.
"""

import os
import sys

BUNDLE = getattr(sys, "_MEIPASS", None) or os.path.dirname(os.path.abspath(sys.executable))

# ---------------------------------------------------------------------------
# 1. TLS trust store.
#    azure-cli/requests call certifi.where(); that resolves inside the bundle
#    fine, but exporting it also fixes child processes and lets corporate
#    MITM proxies override it the normal way.
# ---------------------------------------------------------------------------
_cacert = os.path.join(BUNDLE, "certifi", "cacert.pem")
if os.path.isfile(_cacert):
    os.environ.setdefault("SSL_CERT_FILE", _cacert)
    os.environ.setdefault("REQUESTS_CA_BUNDLE", _cacert)

# ---------------------------------------------------------------------------
# 2. Extensions baked in at build time.
#    azure.cli.core.extension reads config 'extension'/'dir', and knack maps
#    that to AZURE_EXTENSION_DIR (env var format is AZURE_{SECTION}_{OPTION}).
#    Only point at the bundled dir if we actually shipped something and the
#    user has not chosen their own.
# ---------------------------------------------------------------------------
_bundled_ext = os.path.join(BUNDLE, "azext")
if (
    "AZURE_EXTENSION_DIR" not in os.environ
    and os.path.isdir(_bundled_ext)
    and any(n.startswith("azext_") for n in os.listdir(_bundled_ext))
):
    os.environ["AZURE_EXTENSION_DIR"] = _bundled_ext

# ---------------------------------------------------------------------------
# 3. Auto-upgrade would try to pip-install over a frozen bundle. Force it off
#    unless the user has explicitly opted in. (Default is already False, this
#    just guards against an inherited ~/.azure/config.)
#    Note the literal hyphen: knack does NOT normalise section names.
# ---------------------------------------------------------------------------
os.environ.setdefault("AZURE_AUTO-UPGRADE_ENABLE", "false")

# ---------------------------------------------------------------------------
# 4. sysconfig.get_path("purelib") is evaluated at import time by
#    azure.cli.core.extension to build EXTENSIONS_SYS_DIR. In a frozen app
#    sys.prefix is the bundle dir, so it resolves to a path that does not
#    exist - harmless, but make sure it can never raise.
# ---------------------------------------------------------------------------
try:
    import sysconfig

    sysconfig.get_path("purelib")
except Exception:  # pragma: no cover
    import sysconfig as _sc

    _sc.get_path = lambda *a, **k: BUNDLE  # type: ignore[assignment]
