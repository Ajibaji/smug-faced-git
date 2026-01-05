Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
    $completion_file = New-TemporaryFile
    $env:ARGCOMPLETE_USE_TEMPFILES = 1
    $env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
    $env:COMP_LINE = $wordToComplete
    $env:COMP_POINT = $cursorPosition
    $env:_ARGCOMPLETE = 1
    $env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
    $env:_ARGCOMPLETE_IFS = "`n"
    $env:_ARGCOMPLETE_SHELL = 'powershell'
    az 2>&1 | Out-Null
    Get-Content $completion_file | Sort-Object | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
    Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

$env:FNM_DIR = "$HOME\AppData\Local\fnm"
$env:FNM_NODE_DIST_MIRROR = "https://nodejs.org/dist"
$env:FNM_VERSION_FILE_STRATEGY = "local"
$env:FNM_COREPACK_ENABLED = "false"
$env:FNM_LOGLEVEL = "info"
$env:FNM_MULTISHELL_PATH = "$HOME\AppData\Local\fnm_multishells\39336_1706870237743"
$env:FNM_RESOLVE_ENGINES = "false"
$env:FNM_ARCH = "x64"

$env:EGET_BIN = "$HOME\AppData\Local\eget\bin"

$env:PATH += ";$HOME\AppData\Local\Programs\unarWindows"
$env:PATH += ";$HOME\AppData\Local\eget\bin"
function ya {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -Path $cwd
    }
    Remove-Item -Path $tmp
}

function rmm {
  param (
    $dirs_to_delete
  )

  get-childitem -Include ($dirs_to_delete) -Recurse -force  | Remove-Item -Force –Recurse
}

function getCurrentTheme {
  $currentTheme = (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize).SystemUsesLightTheme
  return $currentTheme
}

function setThemeEnvVars {
  param (
    $value = (getCurrentTheme)
  )
  echo $value
  [System.Environment]::SetEnvironmentVariable('LIGHT_THEME', $value, "User") &
  [System.Environment]::SetEnvironmentVariable('CURRENT_THEME', $value -eq 1 ? "LIGHT" : "DARK", "User") &
  $env:LIGHT = $value
  $env:CURRENT_THEME = $value -eq 1 ? "LIGHT" : "DARK"
}

function tt {
  function toggleTheme {
    $newValue = 1 - (getCurrentTheme)

    $activeNvimSessions = @(Get-ChildItem \\.\pipe\nvim*).FullName
    foreach ($pipe in $activeNvimSessions) {
      nvim --remote-send ":lua utils.tt($newvalue)<CR>" --server $pipe &
    }

    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value $newValue -Type Dword &
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value $newValue -Type Dword &
    [System.Environment]::SetEnvironmentVariable('LIGHT_THEME', $newValue, "User") &
    [System.Environment]::SetEnvironmentVariable('CURRENT_THEME', $newValue -eq 1 ? "LIGHT" : "DARK", "User") &
  }

  toggleTheme | Out-Null
}

$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$env:YAZI_CONFIG_HOME = "~\.config\yazi"
$env:FZF_DEFAULT_COMMAND = 'powershell.exe -NoLogo -NoProfile -Noninteractive -Command "Get-ChildItem -File -Recurse -Name"'

function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus

function Get-GitCheckout { & git checkout $args }
New-Alias -Name gco -Value Get-GitCheckout

function lg {
  setThemeEnvVars | Out-Null
  lazygit $args --use-config-file="$env:HOMEPATH/.config/lazygit/$env:CURRENT_THEME-config.yml"
}

function x { explorer $args || '.' }

function Set-Title() {
    $repo = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0) {
        $repo = Split-Path -Leaf $repo
    } else {
        $repo = Split-Path -Leaf (Get-Location)
    }
    $host.UI.RawUI.WindowTitle = $repo
}

function v {
  setThemeEnvVars | Out-Null
  Set-Title
  nvim $args
}

function lsIncludingHidden {
  param (
    $path = '.'
  )

  Get-ChildItem $path -Force
}

Set-Alias -Name ls -Value lsIncludingHidden

function cdThenLs {
  param (
    $path
  )

  Set-Location $path
  lsIncludingHidden
}

Set-Alias -Name cd -Value cdThenLs -Option AllScope

Invoke-Expression (& { (zoxide init powershell | Out-String) })

function Get-ExecutionTime {
    $History = Get-History
    $ExecTime = $History ? ($History[-1].EndExecutionTime - $History[-1].StartExecutionTime) : (New-TimeSpan)
    Write-Output $ExecTime
}

function prompt {
  $ExecTime = Get-ExecutionTime

  $Branch = if ($(git rev-parse --is-inside-work-tree 2>&1) -eq $true) {
    [string]::Format(" {0}({1}){2}", $PSStyle.Foreground.Blue, $(git branch --show-current), $PSStyle.Foreground.White)
  }

  $Venv = if ($env:VIRTUAL_ENV) {
    [string]::Format(" {0}({1}){2}", $PSStyle.Foreground.Magenta, [Path]::GetFileName($env:VIRTUAL_ENV), $PSStyle.Foreground.White)
  }

  return [System.Collections.ArrayList]@(
    "[ ",
    $PSStyle.Foreground.Green,
    $ExecTime.Hours.ToString("D2"),
    ":",
    $ExecTime.Minutes.ToString("D2"),
    ":",
    $ExecTime.Seconds.ToString("D2"),
    $PSStyle.Foreground.White,
    " ] ",
    $PSStyle.Foreground.Yellow,
    $ExecutionContext.SessionState.Path.CurrentLocation,
    $PSStyle.Foreground.White,
    $Branch,
    $Venv,
    "`n  ",
    [string]::new($global:IsAdmin ? "#" : ">", $NestedPromptLevel + 1),
    " "
  ) -join ""
}

# 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'
# 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'
