#Requires -Version 5.1
<#
.SYNOPSIS
    Build a standalone, dependency-free Azure CLI binary for Windows.

.DESCRIPTION
    Pipeline:
      1. create a clean venv on a supported Python (azure-cli requires >=3.10)
      2. pip install azure-cli (+ pyinstaller, + any extensions to bake in)
      3. prune dead weight - chiefly azure/**/aio/, ~129 MB of async SDK
         clients that azure-cli never imports
      4. freeze with PyInstaller
      5. (launcher mode) repack as one solid LZMA stream inside a static Go
         launcher that unpacks once to a cache dir

    PyInstaller cannot cross-compile, so this must run on Windows.

.PARAMETER Mode
    launcher : single static .exe, ~15x compression, unpacks once then instant.
    onefile  : single PyInstaller .exe, re-extracts ~80 MB on every invocation.
    onedir   : plain folder. Fastest, not a single file. Good for debugging.

.EXAMPLE
    .\build.ps1
.EXAMPLE
    .\build.ps1 -AzVersion 2.88.0 -Extensions azure-devops,application-insights
#>
[CmdletBinding()]
param(
    [ValidateSet('launcher', 'onefile', 'onedir')]
    [string]$Mode = 'launcher',

    [string]$AzVersion = '',

    [string]$PythonVersion = '3.12',

    [string[]]$Extensions = @(),

    [ValidateRange(0, 9)]
    [int]$LzmaPreset = 6,

    [switch]$SkipPrune,
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$Root    = $PSScriptRoot
$Build   = Join-Path $Root 'build'
$Venv    = Join-Path $Build 'venv'
$ExtDir  = Join-Path $Build 'azext'
$DistDir = Join-Path $Build 'dist'
$WorkDir = Join-Path $Build 'work'
$Py      = Join-Path $Venv 'Scripts\python.exe'

function Write-Step { param([string]$Text) Write-Host "`n=== $Text ===" -ForegroundColor Cyan }
function Write-Note { param([string]$Text) Write-Host "    $Text" -ForegroundColor DarkGray }

function Get-Size {
    param([string]$Path)
    if (Test-Path $Path -PathType Leaf) { return (Get-Item $Path).Length }
    if (Test-Path $Path) {
        return (Get-ChildItem $Path -Recurse -File | Measure-Object -Sum Length).Sum
    }
    return 0
}
function Format-MB { param([double]$Bytes) '{0,8:N1} MB' -f ($Bytes / 1MB) }

# ---------------------------------------------------------------------------
Write-Step "Preflight"

if ($Clean -and (Test-Path $Build)) {
    Write-Note "removing $Build"
    Remove-Item $Build -Recurse -Force
}

# An existing `az` on this machine is irrelevant - everything is installed
# fresh into a private venv below. But ambient Python/pip environment
# variables CAN silently corrupt the build, so neutralise them for this
# process only. PYTHONPATH is the dangerous one: venvs do NOT ignore it, so
# PyInstaller could resolve `azure` from an outside tree that prune.py never
# touched, and bundle 129 MB of aio/ or a mismatched version.
$hostileEnv = [ordered]@{
    PYTHONPATH = 'would shadow the build venv during PyInstaller analysis'
    PYTHONHOME = 'would break the venv interpreter outright'
    PIP_USER   = 'would redirect installs out of the venv'
    PIP_TARGET = 'would redirect installs out of the venv'
}
foreach ($name in $hostileEnv.Keys) {
    if ([Environment]::GetEnvironmentVariable($name)) {
        Write-Warning "ignoring $name for this build - it $($hostileEnv[$name])"
        [Environment]::SetEnvironmentVariable($name, $null)
    }
}

$basePython = $null
foreach ($candidate in @(
        @{ Exe = 'py';     Args = @("-$PythonVersion") },
        @{ Exe = 'python'; Args = @() })) {
    try {
        $probe = & $candidate.Exe @($candidate.Args + @('-c', 'import sys; print("%d.%d" % sys.version_info[:2])')) 2>$null
        if ($LASTEXITCODE -eq 0 -and $probe) {
            $basePython = $candidate
            Write-Note "python $probe via '$($candidate.Exe) $($candidate.Args)'"
            break
        }
    } catch { }
}
if (-not $basePython) {
    throw "No usable Python found. Install Python $PythonVersion (azure-cli requires >=3.10) and retry."
}

if ($Mode -eq 'launcher' -and -not (Get-Command go -ErrorAction SilentlyContinue)) {
    throw "Mode 'launcher' needs the Go toolchain on PATH. Install Go, or use -Mode onefile."
}

# ---------------------------------------------------------------------------
Write-Step "Creating build venv"

if (-not (Test-Path $Py)) {
    & $basePython.Exe @($basePython.Args + @('-m', 'venv', $Venv))
    if ($LASTEXITCODE -ne 0) { throw "venv creation failed" }
}
& $Py -m pip install --upgrade --quiet pip setuptools wheel
if ($LASTEXITCODE -ne 0) { throw "pip bootstrap failed" }

# ---------------------------------------------------------------------------
Write-Step "Installing azure-cli"

$spec = if ($AzVersion) { "azure-cli==$AzVersion" } else { 'azure-cli' }
Write-Note $spec
& $Py -m pip install --quiet $spec pyinstaller
if ($LASTEXITCODE -ne 0) { throw "failed to install $spec" }

# Assert azure-cli really resolved from inside the venv. If some outside copy
# wins, prune.py and PyInstaller would disagree about what they are operating
# on and the failure would surface much later, very confusingly.
$probe = & $Py -c "import azure.cli.core as c; print(c.__version__); print(c.__file__)"
if ($LASTEXITCODE -ne 0) { throw "azure-cli did not import after install" }
$installedVersion = $probe[0]
$azLocation = $probe[1]
if ($azLocation -notlike "$Venv*") {
    throw "azure-cli resolved to '$azLocation', outside the build venv '$Venv'. Check PYTHONPATH / .pth files."
}
Write-Note "azure-cli $installedVersion (from venv)"

$SitePackages = & $Py -c "import sysconfig; print(sysconfig.get_path('purelib'))"
$sizeBefore = Get-Size $SitePackages
Write-Note "site-packages: $(Format-MB $sizeBefore)"

# ---------------------------------------------------------------------------
if ($Extensions.Count -gt 0) {
    Write-Step "Baking in extensions"
    & $Py (Join-Path $Root 'bake_extensions.py') @Extensions --dest $ExtDir --python $Py
    if ($LASTEXITCODE -ne 0) { throw "extension staging failed" }
}

# ---------------------------------------------------------------------------
if (-not $SkipPrune) {
    Write-Step "Pruning"
    & $Py (Join-Path $Root 'prune.py') $SitePackages
    if ($LASTEXITCODE -ne 0) { throw "prune failed" }
    if (Test-Path $ExtDir) { & $Py (Join-Path $Root 'prune.py') $ExtDir }
    Write-Note "site-packages: $(Format-MB $sizeBefore) -> $(Format-MB (Get-Size $SitePackages))"
}

# ---------------------------------------------------------------------------
Write-Step "Freezing with PyInstaller"
Write-Note "this walks ~8,600 modules and takes a while"

$env:AZSTATIC_ROOT    = $Root
$env:AZSTATIC_MODE    = if ($Mode -eq 'launcher') { 'onedir' } else { $Mode }
$env:AZSTATIC_EXT_SRC = if (Test-Path $ExtDir) { $ExtDir } else { '' }

& $Py -m PyInstaller --noconfirm --clean `
    --distpath $DistDir --workpath $WorkDir `
    (Join-Path $Root 'az.spec')
if ($LASTEXITCODE -ne 0) { throw "PyInstaller failed" }

# ---------------------------------------------------------------------------
Write-Step "Result"

$artifact = $null
switch ($Mode) {
    'onedir' {
        $artifact = Join-Path $DistDir 'az'
    }
    'onefile' {
        $artifact = Join-Path $DistDir 'az.exe'
    }
    'launcher' {
        $frozen = Join-Path $DistDir 'az'
        Write-Note "frozen tree: $(Format-MB (Get-Size $frozen))"

        & $Py (Join-Path $Root 'pack.py') $frozen `
            (Join-Path $Root 'launcher\payload.tar.xz') --preset $LzmaPreset
        if ($LASTEXITCODE -ne 0) { throw "packing failed" }

        Push-Location (Join-Path $Root 'launcher')
        try {
            $env:CGO_ENABLED = '0'
            $env:GOOS = 'windows'
            $env:GOARCH = 'amd64'
            $artifact = Join-Path $Build 'az.exe'
            & go build -trimpath -ldflags '-s -w' -o $artifact .
            if ($LASTEXITCODE -ne 0) { throw "go build failed" }
        } finally {
            Pop-Location
        }
    }
}

Write-Host ""
Write-Host "  artifact : $artifact"
Write-Host "  size     : $(Format-MB (Get-Size $artifact))"
Write-Host "  az       : $installedVersion"
if ($Extensions.Count -gt 0) { Write-Host "  baked    : $($Extensions -join ', ')" }

# ---------------------------------------------------------------------------
Write-Step "Smoke test"

# Run the artifact clean. An existing az install's AZURE_* environment (e.g.
# AZURE_EXTENSION_DIR) would otherwise leak in and make the output describe
# that install rather than this build.
$savedEnv = @{}
foreach ($name in @('AZURE_EXTENSION_DIR', 'AZURE_CONFIG_DIR')) {
    $savedEnv[$name] = [Environment]::GetEnvironmentVariable($name)
    [Environment]::SetEnvironmentVariable($name, $null)
}
try {
    $exe = if (Test-Path $artifact -PathType Leaf) { $artifact } else { Join-Path $artifact 'az.exe' }
    & $exe version
    if ($LASTEXITCODE -ne 0) { Write-Warning "'az version' exited $LASTEXITCODE" }
} finally {
    foreach ($name in $savedEnv.Keys) {
        [Environment]::SetEnvironmentVariable($name, $savedEnv[$name])
    }
}

Write-Host "`nDone.`n" -ForegroundColor Green
