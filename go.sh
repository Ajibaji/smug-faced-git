#!/usr/bin/env bash

set -e

function authGithub() {
  KEY_PATH="${HOME}/.ssh/github_id_ed25519"
  IS_LINUX=${IS_LINUX:-$(test $(uname -s) = "Linux" && echo 'true')}

  mkdir -p ${HOME}/.ssh
  ssh-keygen -t ed25519 -f $KEY_PATH

  if [ -n "${IS_LINUX}" ]; then
    sudo apt update
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

  githubKeyUrl="https://github.com/settings/ssh/new"

  if [ -n "${WSLENV}" ]; then
    if ! command -v wslview; then
      sudo apt install wslu -y
    fi

    printf "\n\n\nOpening browser. Paste key into your GitHub account and save\n"
    wslview $githubKeyUrl
  else
    printf "\n\n\nOpening browser. Paste key into your GitHub account and save\n"
    python3 -m webbrowser "$githubKeyUrl" || python -m webbrowser "$githubKeyUrl"
  fi

  sleep 5
  read -p 'When done, press any key to continue...' continue
}

function cloneAndLink() {
  function createSymLink () {
    local directory="$@"
    directory=$(basename ${directory})
    local sourceDir="${PWD}/${directory}"
    local destDir="${HOME}/.config/${directory}"
    local n="$(( ( RANDOM % 100 )  + 1 ))"

    if [[ -d "$destDir" ]]
    then
      mv ${destDir} ${destDir}-${n}.bak
    fi

    ln -s ${sourceDir} ${destDir}
  }

  export -f createSymLink
  export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

  git clone git@github.com:Ajibaji/smug-faced-git.git ${HOME}/smug-faced-git || git clone https://github.com/Ajibaji/smug-faced-git.git ${HOME}/smug-faced-git

  cd smug-faced-git

  find . -maxdepth 1 \
    -type d \
    -not -path '*.git' \
    -not -path '.' \
    -exec createSymLink '{}' \;

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
  cd ${HOME}/smug-faced-git
  # exec ./install
  ./dotbot-run.sh
  cd -
}

function menu() {
  clear

  PS3="Select choice: "
  select choice in "Authenticate GitHub" "Clone and link dotfiles" "Run DotBot" "Install Brew" Quit
  do
    case $choice in
      "Authenticate GitHub")
        authGithub 
        break;;
      "Clone and link dotfiles")
        cloneAndLink
        break;;
      "Run DotBot")
        runDotbot
	exit 0;;
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
