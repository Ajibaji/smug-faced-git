function authGithub
{
  $KEY_PATH = "${HOME}\.ssh\github_id_ed25519"
  mkdir -p ${HOME}/.ssh
  ssh-keygen -t ed25519 -f $KEY_PATH
  Get-Content $KEY_PATH.pub | Set-Clipboard
  Write-Output "Public key copied to system register"

  Write-Output "Host github.com" >> ~/.ssh/config
  Write-Output "  User git" >> ~/.ssh/config
  Write-Output "  Hostname github.com" >> ~/.ssh/config
  Write-Output "  IdentityFile $KEY_PATH" >> ~/.ssh/config

  Write-Output "Opening browser. Paste key into your GitHub account and save"
  sleep 3
  Start-Process "https://github.com/settings/ssh/new"

  sleep 3
  $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
}

function Show-Menu
{
  param (
    [string]$Title = 'Menu'
  )
  Clear-Host
  Write-Host "================ $Title ================"

  Write-Host "1: Authenticate GitHub"
  Write-Host "2: Clone dotfiles repo"
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
      git clone git@github.com:Ajibaji/smug-faced-git.git
    } '3'
    {
      ./smug-faced-git/dotbot-run.ps1
    }
  }
  pause
}
until ($selection -eq 'q')
