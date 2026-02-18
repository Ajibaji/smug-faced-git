#!/usr/bin/env bash

# install dotbot dependencies and add required apt repositories

function printHeading() {
  printf "%119s\n" ${@}— | sed -e 's/ /—/g';
}

printHeading 'APT-INSTALL-BASE-DEPS'
sudo apt update
sudo apt install make build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev curl git \
  libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev libzstd-dev \
  wget zip unzip apt-transport-https ca-certificates gnupg software-properties-common fontconfig -y

if ! command -v fnm; then
  printHeading 'FNM/NODEJS'
  curl -fssl https://fnm.vercel.app/install | bash -s -- --skip-shell
  FNM_PATH="$HOME/.local/share/fnm"
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
  fnm install v22
  fnm install v20
  fnm default v22
  git checkout -- .
fi

if ! command -v pyenv; then
  printHeading 'INSTALLING-PYENV'
  curl -fsSL https://pyenv.run | bash
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --bash)"
  pyenv install $(pyenv latest -k 3)
  pyenv global $(pyenv latest -k 3)
  git checkout -- .
fi

if ! command -v cargo; then
  printHeading 'INSTALLING-CARGO'
  printf "\n\ninstalling cargo-binstall...\n"
  curl https://sh.rustup.rs -ssf | sh -s -- -y
  curl -l --proto '=https' --tlsv1.2 -ssf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
  export PATH="${HOME}/.cargo/bin:${PATH}"
  cargo binstall -y cargo-update
  cargo install-update -a
  git checkout -- .
fi

if ! command -v dotnet; then
  printHeading 'INSTALLING-DOTNET'
  printf "\n\ninstalling dotnet...\n"
  curl -fsSLO https://dot.net/v1/dotnet-install.sh
  chmod +x ./dotnet-install.sh 
  ./dotnet-install.sh --channel 3.1
  ./dotnet-install.sh --channel 8.0
  ./dotnet-install.sh --channel 9.0
  ./dotnet-install.sh --channel 10.0
  rm dotnet-install.sh
  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools
  dotnet tool install --global csharp-ls --version 0.20.0
  dotnet tool install --global csharpier
fi

if ! command -v az; then
  printHeading 'AZURE-CLI'
  printf "\n\installing azure-cli...\n"
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

if ! command -v R; then
  printHeading 'CRAN-APT-REPO'
  printf "\n\nAdding CRAN (R lang) apt repo...\n"
  sudo apt install --no-install-recommends software-properties-common dirmngr
  wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
  sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y
fi

printHeading 'APT-UPGRADE'
sudo apt update
sudo apt upgrade -y
