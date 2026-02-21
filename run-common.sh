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
  source ~/.bashrc
fi
