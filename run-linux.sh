#!/usr/bin/env bash

# install dotbot dependencies and add required apt repositories

function printHeading() {
  printf "\n\n\n\n%119s\n\n" ${@}— | sed -e 's/ /—/g';
}

if command -v apt > /dev/null 2>&1; then
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
fi

if ! command -v fnm > /dev/null 2>&1; then
  printHeading 'FNM/NODEJS'
  curl -fssl https://fnm.vercel.app/install | bash -s -- --skip-shell
  FNM_PATH="$HOME/.local/share/fnm"
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
  git checkout -- .
fi

if ! command -v pyenv > /dev/null 2>&1; then
  printHeading 'INSTALLING-PYENV'
  curl -fsSL https://pyenv.run | bash
  export PATH="$HOME/.pyenv/bin:$PATH"
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

if ! command -v go > /dev/null 2>&1; then
  printHeading 'INSTALLING-GO'
  LATEST_VERSION="$(curl --silent https://go.dev/VERSION?m=text | head -n 1)";
  URL="https://go.dev/dl/${LATEST_VERSION}.linux-amd64.tar.gz"

  curl -OJ -L --progress-bar $URL
  tar -xf ${LATEST_VERSION}.linux-amd64.tar.gz
  rm ${LATEST_VERSION}.linux-amd64.tar.gz 
  sudo mv ./go /usr/local/ || rm -rf ./go
  mkdir -p $HOME/go/bin
  export PATH=$PATH:/usr/local/go/bin
fi

if ! command -v az > /dev/null 2>&1; then
  printHeading 'AZURE-CLI'
  printf "\n\installing azure-cli...\n"
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

if [[ ! -f ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf ]]; then
  printHeading 'JETBRAINS-FONT'
  mkdir -p ~/.local/share/fonts
  curl -fsSLO --output-dir ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/jetbrainsmono.zip && \
    cd ~/.local/share/fonts && \
    unzip -o jetbrainsmono.zip
  rm jetbrainsmono.zip && \
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

if command -v apt > /dev/null 2>&1; then
  printHeading 'APT-CLEAN-UP'
  sudo apt autoremove -y
fi
