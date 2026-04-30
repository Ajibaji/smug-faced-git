export BASH_PROFILE_LOADED="true"

#___________________________________________________________________________________CARGO:
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"


#________________________________________________________________________________ENV_VARS:
source "$HOME/.config/shell/env.sh"


#________________________________________________________________INTERACTIVE_SHELL_CONFIG:
[ "$BASH_RC_LOADED" = "" ] && source "$HOME/.bashrc"
unset BASH_RC_LOADED


#___________________________________________________________________________________PYENV:
  if [[ "$OS" != "NixOS" && -n "$PS1" ]]; then
    if [ "$PYENV_LOADING" != "" ]; then
        true
    else
        if which pyenv > /dev/null 2>&1; then
            export PYENV_LOADING="true"

            export PYENV_SHELL=bash
            source "$(\ls -1dt /opt/homebrew/Cellar/pyenv/*/ | head -n 1)/completions/pyenv.bash"
            if [[ "$PYENV_ROOT" && "$(type -P python)"  != "$PYENV_ROOT/shims/python" ]]; then
              echo "rehash"
              # command pyenv rehash 2>/dev/null
            fi
            pyenv() {
              local command=${1:-}
              [ "$#" -gt 0 ] && shift
              case "$command" in
              rehash|shell)
                eval "$(pyenv "sh-$command" "$@")"
                ;;
              *)
                command pyenv "$command" "$@"
                ;;
              esac
            }
            unset PYENV_LOADING
        fi
    fi
  fi
