#!/usr/bin/env bash

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STASH=0

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

export BOATING_JEFF=true source $HOME/.bashrc
export OS="$(source /etc/os-release; echo $NAME)"

if [[ "$1" == "symlink" ]]; then
  runSymlink
else
  runSymlink

  if [[ "$OSTYPE" == "darwin"* ]]; then
    printHeading 'MAC-CONFIG'
    ${BASEDIR}/run-macos.sh
  fi

  if [[ "$OSTYPE" == "linux"* ]]; then
    if [[ "$OS" == "NixOS" ]]; then
      printHeading 'NIXOS-CONFIG'
      ${BASEDIR}/run-linux-nixos.sh
    else
      printHeading 'LINUX-CONFIG'
      ${BASEDIR}/run-linux.sh
    fi
  fi

  if [[ "$OS" != "NixOS" ]]; then
    printHeading 'NOT-NOT-YOU-NIXOS'
    ${BASEDIR}/run-not-nixos.sh
  fi

  printHeading 'COMMON-CONFIG'
  ${BASEDIR}/run-common.sh

  printHeading 'POST-RUN-SCRIPTS'
  echo "command: ${BASEDIR}/post-run.sh"
  ${BASEDIR}/post-run.sh

fi
