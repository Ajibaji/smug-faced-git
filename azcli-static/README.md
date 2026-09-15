# azcli-static

Build the Azure CLI into a **single static Windows binary** with no Python runtime,
no `site-packages`, and no installer.

```
official pip/MSI install   ~270 MB, thousands of files, needs Python
this                       ~35 MB, one .exe, needs nothing
```

---

## Why it is 270 MB in the first place

Measured against `azure-cli 2.88.0` (698 MB `site-packages` on this machine):

| Component | Size | Notes |
|---|---:|---|
| `__pycache__/` | 336 MB | byte-for-byte duplicate of the source below |
| `.py` source | 322 MB | 13,307 files |
| native extensions | 26 MB | only ~10 `.pyd`/`.so` files |
| everything else | 14 MB | JSON/YAML data, metadata |

Two things fall out of this immediately:

1. **Half the install is redundant.** Shipping frozen bytecode instead of
   source + cache removes ~322 MB for free.
2. **`azure/**/aio/` is 129 MB of async SDK clients that azure-cli never uses.**
   `grep -r '\.aio' azure/cli/` returns **0 hits** — the CLI is entirely
   synchronous. Safe to delete outright.

The rest is `azure/mgmt` (332 MB) and `azure/cli/command_modules` (201 MB),
almost all machine-generated SDK model code.

### The thing that actually matters: compressor window size

The generated SDK files are enormously redundant *across* files. Deflate's 32 KB
window cannot see that; LZMA's multi-MB window can. Measured on the 228 MB of
reachable bytecode:

| Algorithm | Result | Ratio | Used by |
|---|---:|---:|---|
| zlib −9 | 51.4 MB | 4.4× | zip, PyInstaller's `PYZ`, `--onefile` |
| **LZMA −6** | **15.0 MB** | **15.2×** | this build |

Choosing the right compressor is worth **3.4× more than all pruning combined**.
That single measurement is what the design below is built around.

### What was deliberately *not* done

Pruning unused `azure/mgmt/**/vYYYY_MM_DD/` API-version folders looks tempting
(133 MB across 119 directories). It was measured and rejected: the CLI genuinely
references **102 of the 119**, so the real saving is ~16 MB, in exchange for
`ImportError` on obscure subcommands. Bad trade.

---

## Approach

| Option | Single file? | Size | Startup | Verdict |
|---|---|---:|---|---|
| PyInstaller `--onedir` | no | ~250 MB | fast | debugging only |
| PyInstaller `--onefile` | yes | ~80 MB | **re-extracts ~80 MB every run** | painful for a CLI |
| Nuitka `--onefile` | yes | — | — | compiles 8,600 modules to C; hours, and bigger |
| **Go launcher + solid LZMA** | **yes** | **~35 MB** | **one-time unpack, then instant** | **default** |

The default `launcher` mode embeds the entire frozen tree as one solid LZMA
stream inside a static Go binary (`CGO_ENABLED=0`). On first run it unpacks to
`%LOCALAPPDATA%\az-static\<payload-id>\`; every run after that just execs the
already-unpacked `az.exe`.

Verified behaviour: exit codes and arguments pass through unchanged, warm start
adds **19 ms**, and 8 concurrent cold starts race safely to a single cache
directory with no leftover temp dirs.

---

## Usage

Must run **on Windows** — PyInstaller cannot cross-compile.

**`az` does not need to be installed.** The build never touches a system Azure
CLI: it creates a private venv, `pip install`s `azure-cli` into it, and
`bake_extensions.py` downloads extension wheels straight from the Azure index
rather than shelling out to `az extension add`. An existing install is neither
used nor modified.

Prerequisites are only:

| Requirement | Needed for |
|---|---|
| Windows | PyInstaller can't cross-compile |
| Python ≥3.10 | the build venv (3.12 is the default and safest) |
| Network access | PyPI + the extension index |
| Go toolchain | `launcher` mode only |

An existing `az` can't help the build, but a hostile *environment* can break it,
so `build.ps1` neutralises `PYTHONPATH`, `PYTHONHOME`, `PIP_USER` and
`PIP_TARGET` for its own process and then asserts that `azure.cli.core` actually
resolved from inside the venv. (Venvs do **not** ignore `PYTHONPATH` — without
that guard, PyInstaller could bundle an outside copy that `prune.py` never
touched.) The smoke test likewise runs with `AZURE_EXTENSION_DIR` /
`AZURE_CONFIG_DIR` cleared, so its output describes the new binary rather than
any pre-existing install.

```powershell
# default: single static exe
.\build.ps1

# pin a version and bake in extensions so they work offline
.\build.ps1 -AzVersion 2.88.0 -Extensions azure-devops,application-insights

# no Go toolchain available
.\build.ps1 -Mode onefile

# iterate on a broken build
.\build.ps1 -Mode onedir -SkipPrune
```

Output lands in `build\az.exe`. Copy it anywhere and run it.

| Flag | Default | Purpose |
|---|---|---|
| `-Mode` | `launcher` | `launcher` / `onefile` / `onedir` |
| `-AzVersion` | latest | pin the azure-cli release |
| `-PythonVersion` | `3.12` | which interpreter `py -X` selects |
| `-Extensions` | none | pre-install CLI extensions into the binary |
| `-LzmaPreset` | `6` | 9 is ~2% smaller and far slower |
| `-SkipPrune` | off | keep `aio/` etc. for diagnosis |
| `-Clean` | off | wipe `build\` first |

---

## Files

| File | Role |
|---|---|
| `build.ps1` | orchestrates the whole pipeline |
| `prune.py` | deletes `aio/`, `tests/`, stubs, caches (**frees 448 MB**) |
| `az.spec` | PyInstaller spec — hidden imports, data files, exclusions |
| `az_entry.py` | frozen entry point; also implements `az.exe -m <module>` |
| `rthook_az.py` | runtime hook — certs, extension dir, auto-upgrade guard |
| `pack.py` | solid `tar.xz` packer (stdlib only) + payload fingerprint |
| `launcher/main.go` | static single-file launcher with cached extraction |
| `bake_extensions.py` | pulls extension wheels from the Azure index |

`prune.py` runs **before** PyInstaller on purpose: `collect_submodules()` walks
the filesystem, so anything already deleted cannot enter the module graph.

> `go build` in `launcher/` fails on its own with *"pattern payload.id: no
> matching files found"*. That is expected — `build.ps1` runs `pack.py` to
> generate the payload first.

---

## Non-obvious problems this solves

**Command modules are discovered dynamically.** `azure.cli.core` does
`pkgutil.iter_modules(import_module('azure.cli.command_modules').__path__)`, and
SDK clients are resolved by string name from `azure.cli.core.profiles`. Neither
is visible to static analysis, so `az.spec` names every submodule explicitly via
`collect_submodules`.

**`az extension add` shells out to pip.** `azure.cli.core.extension.operations`
runs `[sys.executable, '-m', 'pip', 'install', '--target', ...]`, and in a frozen
build `sys.executable` is `az.exe`. Rather than break extensions,
`az_entry.py` honours `-m <module>` and pip is bundled — so that subprocess
resolves to a real pip run inside the embedded interpreter, with wheel markers
correctly matching the bundled Python. Extensions keep working at runtime.

**Extension directory.** `rthook_az.py` points `AZURE_EXTENSION_DIR` at the baked-in
extensions only when some were baked and the user has not set their own.
(knack's env var format is `AZURE_{SECTION}_{OPTION}`, section names not
normalised — hence the literal hyphen in `AZURE_AUTO-UPGRADE_ENABLE`.)

**Certificates.** `SSL_CERT_FILE` / `REQUESTS_CA_BUNDLE` are exported from the
bundled `certifi`, so child processes inherit them and corporate MITM proxies can
still override them the usual way.

---

## Known limitations

- **`az upgrade` cannot work** — there is no pip-managed install to upgrade.
  It is intercepted with a clear message; replace the binary instead.
  (`AZ_STATIC_ALLOW_UPGRADE=1` bypasses the guard, and will fail.)
- **Unsigned binaries trip SmartScreen/AV.** Both PyInstaller bootloaders and
  Go binaries are frequent false-positive magnets. Sign the output with
  `signtool` for any real distribution.
- **The build is slow.** PyInstaller walks ~8,600 modules; expect 10–30 minutes
  and several GB of RAM.
- **First run unpacks ~250 MB** to `%LOCALAPPDATA%` (a few seconds, once per
  version). Set `AZ_STATIC_HOME` to relocate it. Disk use is therefore *higher*
  than the 35 MB binary once warmed — the win is distribution, not footprint.
- **Extensions with compiled dependencies** need wheels matching the bundled
  Python's version and ABI.
- Telemetry still works as normal; disable with `AZURE_CORE_COLLECT_TELEMETRY=false`.

---

## Verifying a build

```powershell
build\az.exe version
build\az.exe login --use-device-code
build\az.exe group list -o table
build\az.exe vm list -o table          # exercises the largest command module
build\az.exe extension list -o table
```

`az vm` and `az network` are the best canaries — they pull the most dynamically
resolved SDK surface, so a missing hidden import shows up there first.
