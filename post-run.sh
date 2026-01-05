#!/usr/bin/env bash

# post-install configuration scripts go here

function printHeading() {
  printf "%119s\n" ${@}— | sed -e 's/ /—/g';
}

if command -v pip3; then
  printHeading 'PIP-TRUST-SYSTEM-CERTS'
  pip3 install --trusted-host files.pythonhosted.org pip_system_certs
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
  printHeading 'MAC-CONFIG'
  echo "There are no MacOS-only post-install scripts yet"
else
  printHeading 'DOCKER-PERMISSIONS'
  printf "\n\nAllowing docker to be used by non-root...\n"
  sudo groupadd -f docker
  sudo usermod -aG docker $(whoami)
  rm -rf ~/.docker
  newgrp docker
fi
