#!/usr/bin/env bash

# post-install configuration scripts go here

function printHeading() {
  printf "%119s\n" ${@}— | sed -e 's/ /—/g';
}

# OS-agnostic scripts go here
if command -v pip > /dev/null 2>&1; then
  printHeading 'PIP-TRUST-SYSTEM-CERTS'
  pip install --trusted-host files.pythonhosted.org pip_system_certs
fi

# OS-specific scripts go here
if [[ "$OSTYPE" == "darwin"* ]]; then
  printHeading 'MAC-ONLY'
  echo "There are no MacOS-only post-install scripts yet"
elif [[ "$OSTYPE" == "linux"* ]]; then
  printHeading 'LINUX-ONLY'
  echo "There are no Linux-only post-install scripts yet"
fi
