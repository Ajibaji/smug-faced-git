#!/usr/bin/env bash

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function printHeading() {
  printf "%119s\n" ${@}— | sed -e 's/ /—/g';
}

export -f printHeading

function runSymlink() {
  printHeading LINKING-FILES
  echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v"
  ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v
}

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive

if [[ "$@" == "symlink" ]]; then
  runSymlink
else
  runSymlink

  if [[ "$OSTYPE" == "darwin"* ]]; then
    printHeading 'MAC-CONFIG'
    echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} --plugin-dir dotbot-brew -c mac.conf.yaml"
    "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" --plugin-dir dotbot-brew -c "mac.conf.yaml"
  else
    printHeading 'LINUX-PRE-RUN'
    echo "command: ${BASEDIR}/pre-run.sh"
    ${BASEDIR}/pre-run.sh
    export PATH="${HOME}/.cargo/bin:${PATH}"

    printHeading 'LINUX-BASE-CONFIG'
    echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c linux-base.conf.yaml -v"
    ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c linux-base.conf.yaml -v

    printHeading 'APT-INSTALL'
    echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -p dotbot-apt/apt.py -c apt.conf.yaml -v"
    sudo ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -p dotbot-apt/apt.py -c apt.conf.yaml -v
    sudo apt autoremove -y

    printHeading 'LINUX-POST-RUN'
    echo "command: ${BASEDIR}/post-run.sh"
    ${BASEDIR}/post-run.sh
  fi
fi
