#!/usr/bin/env bash

# install dotbot dependencies and add required apt repositories

function printHeading() {
  printf "%119s\n" ${@}— | sed -e 's/ /—/g';
}

printHeading 'APT-INSTALL-BASE-DEPS'
sudo apt update -qq
sudo apt install \
  apt-transport-https \
  build-essential \
  ca-certificates \
  curl \
  dirmngr \
  dolphin \
  dos2unix \
  fontconfig \
  git \
  gnupg \
  imagemagick \
  libbz2-dev \
  libcurl4-openssl-dev \
  libffi-dev \
  liblzma-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libvulkan-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libzstd-dev \
  lsb-release \
  lsof \
  make \
  parallel \
  podman \
  poppler-utils \
  progress \
  siege \
  socat \
  software-properties-common \
  strace \
  tk-dev \
  tree \
  unzip \
  wget \
  xz-utils \
  zip \
  zlib1g-dev \
  -y -qq

if ! command -v fnm > /dev/null 2>&1; then
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

if ! command -v pyenv > /dev/null 2>&1; then
  printHeading 'INSTALLING-PYENV'
  curl -fsSL https://pyenv.run | bash
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init --bash)"
  pyenv install $(pyenv latest -k 3)
  pyenv global $(pyenv latest -k 3)
  git checkout -- .
fi

if ! command -v cargo > /dev/null 2>&1; then
  printHeading 'INSTALLING-CARGO'
  printf "\n\ninstalling cargo-binstall...\n"
  curl https://sh.rustup.rs -ssf | sh -s -- -y
  curl -l --proto '=https' --tlsv1.2 -ssf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
  export PATH="${HOME}/.cargo/bin:${PATH}"
  cargo binstall -y cargo-update
  cargo install-update -a
  git checkout -- .
fi

if ! command -v dotnet > /dev/null 2>&1; then
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

if ! command -v az > /dev/null 2>&1; then
  printHeading 'AZURE-CLI'
  printf "\n\installing azure-cli...\n"
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

if ! command -v R > /dev/null 2>&1; then
  printHeading 'CRAN-APT-REPO'
  printf "\n\nAdding CRAN (R lang) apt repo...\n"
  wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
  sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y
  sudo apt update -qq
  sudo apt install r-base -y -qq
fi

export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
if ! command git ls-remote git@github.com:Ajibaji/seeshellontheseasaw.git > /dev/null 2>&1; then
  printHeading 'SEESHELLONTHESEASAW'
  echo "You aren't me. Nothing to see here"
else
  printHeading 'SEESHELLONTHESEASAW'
  if [ ! -d ~/seeshellontheseasaw ]; then
    git clone git@github.com:ajibaji/seeshellontheseasaw.git ~/seeshellontheseasaw
  else
    git -C ~/seeshellontheseasaw pull --quiet
  fi
  source ~/.bashrc
fi
unset GIT_SSH_COMMAND

if ! command -v atuin > /dev/null 2>&1; then
printHeading 'ATUIN'
  export NO_MODIFY_PATH=1
  curl --proto '=https' --tlsv1.2 -lssf https://setup.atuin.sh | sh
  git checkout -- .
fi

if [[ ! -f ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf ]]; then
  printHeading 'JETBRAINS-FONT'
  sudo mkdir -p ~/.local/share/fonts
  sudo curl -fsSLO --output-dir ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/jetbrainsmono.zip && \
    cd ~/.local/share/fonts && \
    sudo unzip -o jetbrainsmono.zip
  sudo rm jetbrainsmono.zip && \
    fc-cache -fv
  cd -
fi

if ! command -v ghostty > /dev/null 2>&1; then
  printHeading 'GHOSTTY'
  sudo snap install ghostty --classic
fi

if ! command -v bun > /dev/null 2>&1; then
  printHeading 'INSTALLING-BUN'
  npm i -g bun --loglevel error
fi

printHeading 'BUN-DEPS'
bun i -g \
  @biomejs/biome \
  azure-pipelines-language-server \
  corepack \
  dockerfile-language-server-nodejs \
  neovim \
  sql-language-server \
  typescript \
  typescript-language-server

if ! command -v go > /dev/null 2>&1; then
  printHeading 'INSTALLING-GO'
  LATEST_VERSION="$(curl --silent https://go.dev/VERSION?m=text | head -n 1)";
  URL="https://go.dev/dl/${LATEST_VERSION}.linux-amd64.tar.gz"
  
  curl -OJ -L --progress-bar $URL
  tar -xf ${LATEST_VERSION}.linux-amd64.tar.gz
  rm ${LATEST_VERSION}.linux-amd64.tar.gz 
  sudo mv ./go /usr/local/ || rm -rf ./go
  [[ -z "$GOBIN" ]] && mkdir -p $GOBIN
fi

if ! command -v eget > /dev/null 2>&1; then
  printHeading 'INSTALLING-EGET'
  # TODO: fork the repo and add changes when you get the chance
  cd eget/eget
  go build -trimpath -ldflags "-s -w -X main.Version=1.3.2-dev.99" -o dist/bin/eget .
  sudo mv ./dist/bin/eget /usr/local/bin/eget
  cd -
fi

printHeading 'EGET-DEPS'
eget -D

printHeading 'APT-CLEAN-UP'
sudo apt autoremove -y
