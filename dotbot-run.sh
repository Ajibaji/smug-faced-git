#!/usr/bin/env bash

set -e

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v ${@}"
  ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v ${@}

  echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} --plugin-dir dotbot-brew -c mac.conf.yaml ${@}"
  "${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" --plugin-dir dotbot-brew -c "mac.conf.yaml" "${@}"
else
  echo "command: ${BASEDIR}/pre-run.sh"
  ${BASEDIR}/pre-run.sh
  export PATH="${HOME}/.cargo/bin:${PATH}"

  echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v ${@}"
  ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c base.conf.yaml -v ${@}

  echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c linux-base.conf.yaml -v ${@}"
  ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -c linux-base.conf.yaml -v ${@}

  echo "command: ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -p dotbot-apt/apt.py -c linux-apt.conf.yaml -v ${@}"
  sudo ${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN} -d ${BASEDIR} -p dotbot-apt/apt.py -c apt.conf.yaml -v ${@}

  echo "command: ${BASEDIR}/post-run.sh"
  ${BASEDIR}/post-run.sh
fi
