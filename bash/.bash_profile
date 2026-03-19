export BASH_PROFILE_LOADED="true"

#___________________________________________________________________________________CARGO:
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"


#________________________________________________________________________________ENV_VARS:
source "$HOME/.config/shell/env.sh"


#___________________________________________________________________________________PYENV:
  if [[ "$OS" != "NixOS" ]]; then
    export PYENV_SHELL=bash
    source "/opt/homebrew/Cellar/pyenv/$(pyenv --version | awk '{print $2}')/completions/pyenv.bash"
    pyenv rehash
  fi


#________________________________________________________________INTERACTIVE_SHELL_CONFIG:
[ -z "$BASH_RC_LOADED" ] && source "$HOME/.bashrc"
