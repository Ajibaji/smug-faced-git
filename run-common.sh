#!/usr/bin/env bash

function printHeading() {
  printf "\n\n\n\n%119s\n\n" ${@}— | sed -e 's/ /—/g';
}

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
fi

if command -v pyenv > /dev/null 2>&1; then
  printHeading 'PYENV-INSTALLS'
  eval "$(pyenv init - --bash)"
  pyenv install $(pyenv latest -k 3)
  pyenv global $(pyenv latest -k 3)
fi

if ! command -v eget > /dev/null 2>&1; then
  printHeading 'INSTALLING-EGET'
  # TODO: fork the repo and add changes when you get the chance
  cd eget/eget
  go build -trimpath -ldflags "-s -w -X main.Version=1.3.2-dev.99" -o dist/bin/eget .
  mv ./dist/bin/eget $EGET_BIN
  cd -
fi

if command -v eget > /dev/null 2>&1; then
  printHeading 'EGET-DEPS'
  eget -D
fi

if command -v fnm > /dev/null 2>&1; then
  printHeading 'FNM-INSTALLS'
  fnm install v22
  fnm default v22
  eval "`fnm env`"
fi

if ! command -v bun > /dev/null 2>&1; then
  printHeading 'INSTALLING-BUN'
  npm i -g bun --loglevel error
fi
