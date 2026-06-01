#!/usr/bin/env bash

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STASH=0

if [[ -f "/etc/os-release" ]]; then
  export OS="$(source /etc/os-release; echo $NAME)"
else
  export OS="MacOS"
fi

function printHeading() {
  printf "\n\n\n\n%139s\n\n" ${@}— | sed -e 's/ /—/g';
}

export -f printHeading

function runSymlink() {
  printHeading LINKING-FILES
  echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v"
  ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v
}

function tearDown() {
  [[ $STASH -gt 0 ]] && git stash pop
}

trap 'tearDown' SIGHUP SIGINT SIGQUIT SIGTERM SIGABRT

cd "${BASEDIR}"
STASH=$(git status -u -s | wc -l)
[[ $STASH -gt 0 ]] && git stash push --all

git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive

source $HOME/.config/shell/env.sh

if [[ "$1" == "symlink" ]]; then
  runSymlink
else
  runSymlink

  if [[ "$OS" == "NixOS" ]]; then
    printHeading 'NO-NOT-YOU-NIXOS'
    echo "This rest of this script doesn't cater to NIXOS. Use the NIXOS config instead."
    echo "Exiting..."
    return
  fi

  if [[ "$OS" == "MacOS" ]]; then
    printHeading 'MAC-CONFIG'
    ${BASEDIR}/run-macos.sh
  else
    printHeading 'LINUX-CONFIG'
    export PATH=$(echo $PATH | tr ':' '\n' | grep -v /mnt/ | tr '\n' ':') # clear $PATH of any windows entries
    ${BASEDIR}/run-linux.sh
  fi

  printHeading 'COMMON-CONFIG'
  ${BASEDIR}/run-common.sh

  printHeading 'POST-RUN-SCRIPTS'
  ${BASEDIR}/post-run.sh

fi
