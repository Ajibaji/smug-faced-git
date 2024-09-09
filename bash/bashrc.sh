#________________________________________________________________________________ENV_VARS:
    source ${HOME}/.config/shell/env.sh

#_____________________________________________________ALIASES,_FUNCTIONS_&_THEME_SWITCHER:
    source ${HOME}/.config/shell/salad-source.sh

#_____________________________________________________________________________________RUN:
    if [[ "$PWD" == "/mnt/"* ]]; then
      cd ~
    fi
