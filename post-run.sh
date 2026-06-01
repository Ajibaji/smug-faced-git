#!/usr/bin/env bash

#
# OS-agnostic scripts go here
#

function printHeading() {
  printf "\n\n\n\n%119s\n\n" ${@}— | sed -e 's/ /—/g';
}

OS="$(source /etc/os-release; echo $NAME)"

if [[ ! -f $HOME/.cache/bat/themes.bin ]] && command -v bat > /dev/null 2>&1; then
  printHeading 'BAT-CACHE-BUILD'
  bat cache --build
fi

if command -v bun > /dev/null 2>&1; then
  printHeading 'BUN-DEPS'
  bun i -g \
    @biomejs/biome \
    @mariozechner/pi-coding-agent \
    azure-pipelines-language-server \
    corepack \
    dockerfile-language-server-nodejs \
    neovim \
    sql-language-server \
    typescript \
    typescript-language-server
fi

if command -v pyenv > /dev/null 2>&1; then
  printHeading 'PIP-INSTALLS'
  pip install --trusted-host files.pythonhosted.org certifi pip_system_certs
fi

if ! command -v az > /dev/null 2>&1; then
  printHeading 'AZURE-CLI-INSTALL'
  pip install azure-cli
fi

if command -v az > /dev/null 2>&1; then
  printHeading 'AZURE-CLI-CONFIG-AND-UPGRADE'
  az config set extension.dynamic_install_allow_preview=true
  az extension add --name azure-devops --upgrade -y
  az upgrade --all -y
fi

if command -v dotnet > /dev/null 2>&1; then
  printHeading 'DOTNET-TOOLS'
  dotnet tool install --global csharp-ls --version 0.20.0
  dotnet tool install --global csharpier
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  printHeading 'MAC-ONLY'
  echo "There are no MacOS-only post-install scripts yet"
elif [[ "$OSTYPE" == "linux"* ]]; then
  printHeading 'LINUX-ONLY'
  echo "There are no Linux-only post-install scripts yet"
fi
