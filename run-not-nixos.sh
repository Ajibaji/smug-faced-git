#!/usr/bin/env bash

function printHeading() {
  printf "\n\n\n\n%119s\n\n" ${@}— | sed -e 's/ /—/g';
}

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
fi

if ! command -v eget > /dev/null 2>&1; then
  printHeading 'INSTALLING-EGET'
  # TODO: fork the repo and add changes when you get the chance
  cd eget/eget
  go build -trimpath -ldflags "-s -w -X main.Version=1.3.2-dev.99" -o dist/bin/eget .
  mv ./dist/bin/eget $EGET_BIN
  cd -
fi

# if ! command -v atuin > /dev/null 2>&1; then
#   printHeading 'ATUIN'
#   export NO_MODIFY_PATH=1
#   curl --proto '=https' --tlsv1.2 -lssf https://setup.atuin.sh | sh
#   git checkout -- .
# fi
