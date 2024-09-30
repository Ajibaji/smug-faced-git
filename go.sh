#!/usr/bin/env bash

set -e

function authGithub() {
  KEY_PATH="${HOME}/.ssh/github_id_ed25519"
  IS_LINUX=${IS_LINUX:-$(test $(uname -s) = "Linux" && echo 'true')}

  mkdir -p ${HOME}/.ssh
  ssh-keygen -t ed25519 -f $KEY_PATH

  if [ -n "${IS_LINUX}" ]; then
    if ! command -v xsel; then
      sudo apt install xsel -y
    fi
    cat ${KEY_PATH}.pub | xsel --clipboard --input
  fi

  [ -z "${IS_LINUX}" ] && cat ${KEY_PATH}.pub | pbcopy

  echo "Public key copied to system register"

  echo "Host github.com" >> ~/.ssh/config
  echo "  User git" >> ~/.ssh/config
  echo "  Hostname github.com" >> ~/.ssh/config
  echo "  IdentityFile $KEY_PATH" >> ~/.ssh/config

  echo "Opening browser. Paste key into your GitHub account and save"
  githubKeyUrl="https://github.com/settings/ssh/new"

  if [ -n "${WSLENV}" ]; then
    if ! command -v wslview; then
      sudo apt install wslu -y
    fi

    wslview $githubKeyUrl
  else
    python3 -m webbrowser "$githubKeyUrl" || python -m webbrowser "$githubKeyUrl"
  fi

  sleep 5
  read -p 'When done, press any key to continue...' continue
}

function cloneAndMerge() {
  local n="$(( ( RANDOM % 100 )  + 1 ))"
  mv ${HOME}/.config ${HOME}/.config.${n}.bak

  # git clone https://github.com/Ajibaji/smug-faced-git.git ${HOME}/.config
  git clone git@github.com:Ajibaji/smug-faced-git.git ${HOME}/.config

  mv -n ${HOME}/.config.${n}.bak/* ${HOME}/.config/

  export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
  if ! command git ls-remote git@github.com:Ajibaji/seeshellontheseasaw.git; then
    rm -rf ${HOME}/.config/.git
  fi
  unset GIT_SSH_COMMAND
}

function installBrew() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  else
    echo "This option is Mac only"
    sleep 2
  fi
}

function runDotbot() {
  if ! command -v wget; then
    sudo apt install wget -y
  fi

  if ! command -v zip; then
    sudo apt install zip -y
  fi

  if ! command -v unzip; then
    sudo apt install unzip -y
  fi

  if ! command -v fnm; then
    curl -fssl https://fnm.vercel.app/install | bash
    source ~/.bashrc
    echo "fnm path: $FNM_PATH"
    eval "`fnm env`"
    fnm install v20
    fnm install v18
    fnm install v16
    fnm default v20
  fi

  if ! command -v cargo; then
    curl https://sh.rustup.rs -ssf | sh -s -- -y
    curl -l --proto '=https' --tlsv1.2 -ssf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
    source ~/.bashrc
    cargo binstall -y cargo-update
    cargo install-update -a
  fi

  cd ${HOME}/.config
  exec ./install
}

function menu() {
  clear

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
        exit 0;;
      *)
        echo "Invalid selection";;
    esac
  done
}

while [ true ]
do
  menu
done
