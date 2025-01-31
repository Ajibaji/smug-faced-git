function authGithub
{
  $KEY_PATH = "${HOME}\.ssh\github_id_ed25519"
  mkdir -p ${HOME}/.ssh
  ssh-keygen -t ed25519 -f $KEY_PATH
  Get-Content $KEY_PATH | Set-Clipboard
  Write-Output "Public key copied to system register"

  Write-Output "Host github.com" >> ~/.ssh/config
  Write-Output "  User git" >> ~/.ssh/config
  Write-Output "  Hostname github.com" >> ~/.ssh/config
  Write-Output "  IdentityFile $KEY_PATH" >> ~/.ssh/config

  Write-Output "Opening browser. Paste key into your GitHub account and save"
  Start-Process "https://github.com/settings/ssh/new"

  sleep 5
  $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
}

function cloneAndMerge
{
  # rm -rf ${HOME}/.config.bak
  # remove-item -ErrorAction Ignore ${HOME}/.config.bak

  # mv ${HOME}/.config ${HOME}/.config.bak
  git clone git@github.com:Ajibaji/smug-faced-git.git
  # mv -n ${HOME}/.config.bak/* ${HOME}/.config/ && rm -rf ${HOME}/.config.bak
}

function runDotbot
{
  ./install.ps1
  # Invoke-Command -FilePath C:\Users\aarjomandkhah\.config\install.ps1
}

function Show-Menu
{
  param (
    [string]$Title = 'Menu'
  )
  Clear-Host
  Write-Host "================ $Title ================"

  Write-Host "1: Authenticate GitHub"
  Write-Host "2: Clone and merge dotfiles"
  Write-Host "3: Run DotBot"
  Write-Host "Q: Press 'Q' to quit."
}

Set-Location ${HOME}

do
{
  Show-Menu -Title 'Configure new machine'
  $selection = Read-Host "Please make a selection"
  switch ($selection)
  {
    '1'
    {
      authGithub
    } '2'
    {
      cloneAndMerge
    } '3'
    {
      runDotBot
    }
  }
  pause
}
until ($selection -eq 'q')
