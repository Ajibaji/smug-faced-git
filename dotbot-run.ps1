$ErrorActionPreference = "Stop"

$CONFIG = "win.conf.yaml"
$DOTBOT_DIR = "dotbot"

$DOTBOT_BIN = "bin\dotbot"
$BASEDIR = $PSScriptRoot
echo $BASEDIR
# return
# Set-Location $BASEDIR
#
# $configPath = "${HOME}/.config"
# $randomNumber = Get-Random -Maximum 1000
# $configBackupPath = "${HOME}/.config.$randomNumber"
#
# Set-Location $DOTBOT_DIR && git submodule update --init --recursive
#
# if (Test-Path $configPath){
#   mv $configPath $configBackupPath
# }
#
# foreach ($PYTHON in ('python', 'python3')) {
#   # Python redirects to Microsoft Store in Windows 10 when not installed
#   if (& { $ErrorActionPreference = "SilentlyContinue"
#       ![string]::IsNullOrEmpty((&$PYTHON -V))
#       $ErrorActionPreference = "Stop" }) {
#     &$PYTHON $(Join-Path $BASEDIR -ChildPath $DOTBOT_DIR | Join-Path -ChildPath $DOTBOT_BIN) -d $BASEDIR -c $CONFIG $Args
#
#     if (Test-Path $configBackupPath){
#       # merge files from old config that are missing from newly created config
#       mv -n $configBackupPath/* $configPath/
#     }
#     return
#   }
# }
# Write-Error "Error: Cannot find Python."
