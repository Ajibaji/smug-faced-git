#!/usr/bin/env bash

set -e

function authGithub() {
  KEY_PATH="${HOME}/.ssh/github_id_ed25519"
  IS_LINUX=${IS_LINUX:-$(test $(uname -s) = "Linux" && echo 'true')}

  mkdir -p ${HOME}/.ssh
  ssh-keygen -t ed25519 -f $KEY_PATH
  [ -n "${IS_LINUX}" ] && cat ${KEY_PATH}.pub | xsel --clipboard --input
  [ -z "${IS_LINUX}" ] && cat ${KEY_PATH}.pub | pbcopy
  echo "Public key copied to system register"

  echo "Host github.com" >> ~/.ssh/config
  echo "  User git" >> ~/.ssh/config
  echo "  Hostname github.com" >> ~/.ssh/config
  echo "  IdentityFile $KEY_PATH" >> ~/.ssh/config

  echo "Opening browser. Paste key into your GitHub account and save"
  python -m webbrowser "https://github.com/settings/ssh/new"

  sleep 5
  read -p 'When done, press any key to continue...' continue
}

function cloneAndMerge() {
  rm -rf ${HOME}/.config.bak
  mv ${HOME}/.config ${HOME}/.config.bak
  git clone git@github.com:Ajibaji/smug-faced-git.git ${HOME}/.config
  mv -n ${HOME}/.config.bak/* ${HOME}/.config/ && rm -rf ${HOME}/.config.bak
}

function installBrew() {
  if ! command -v brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

function runDotbot() {
  cd ${HOME}/.config
  exec ./install
}

PS3="Select choice: "

select choice in "Authenticate GitHub" "Clone and merge dotfiles" "Run DotBot" "Install Brew" Quit
do
    case $choice in
        "Authenticate GitHub")
           authGithub
	   break;;
        "Clone and merge dotfiles")
           cloneAndMerge
	   break;;
        "Run DotBot")
           runDotbot
	   break;;
        "Install Brew")
           installBrew
	   break;;
        "Quit")
           echo "We're done"
           break;;
        *)
           echo "Invalid selection";;
    esac
done
