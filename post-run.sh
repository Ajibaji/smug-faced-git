#!/usr/bin/env bash

# post-install configuration scripts go here

function printHeading() {
  printf "\n\n\n\n%119s\n\n" ${@}— | sed -e 's/ /—/g';
}

#
# OS-agnostic scripts go here
#

OS="$(source /etc/os-release; echo $NAME)"


if [[ "$OS" != "NixOS" ]]; then
  # pyenv
  if command -v pyenv > /dev/null 2>&1; then
    printHeading 'PYENV-INSTALLS'
    eval "$(pyenv init - --bash)"
    pyenv install $(pyenv latest -k 3)
    pyenv global $(pyenv latest -k 3)
    pip install --trusted-host files.pythonhosted.org pip_system_certs
  fi
  
  # fnm
  if command -v fnm > /dev/null 2>&1; then
    printHeading 'FNM-INSTALLS'
    fnm install v22
    fnm default v22
    eval "`fnm env`"
  fi
fi

# bat
if [[ ! -f $HOME/.cache/bat/themes.bin ]] && command -v bat > /dev/null 2>&1; then
  printHeading 'BAT-CACHE-BUILD'
  bat cache --build
fi

# bun
if ! command -v bun > /dev/null 2>&1; then
  printHeading 'INSTALLING-BUN'
  npm i -g bun --loglevel error
fi

if command -v bun > /dev/null 2>&1; then
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
fi

# dotnet
if command -v dotnet > /dev/null 2>&1; then
  printHeading 'DOTNET-TOOLS'
  dotnet tool install --global csharp-ls --version 0.20.0
  dotnet tool install --global csharpier
fi

# eget
if command -v eget > /dev/null 2>&1; then
  printHeading 'EGET-DEPS'
  eget -D
fi

# OS-specific scripts go here
if [[ "$OSTYPE" == "darwin"* ]]; then
  printHeading 'MAC-ONLY'
  echo "There are no MacOS-only post-install scripts yet"
elif [[ "$OSTYPE" == "linux"* ]]; then
  printHeading 'LINUX-ONLY'
  echo "There are no Linux-only post-install scripts yet"
fi
