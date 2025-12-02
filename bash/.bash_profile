echo "$(date -u '+%S.%N') .bash_profile started" >> /Users/aarjomandkhah/jeff.log
export BASH_PROFILE_LOADED="true"

#___________________________________________________________________________________CARGO:
source "$HOME/.cargo/env"


#________________________________________________________________________________ENV_VARS:
source "$HOME/.config/shell/env.sh"


#________________________________________________________________INTERACTIVE_SHELL_CONFIG:
[ -z "$BASH_RC_LOADED" ] && source "$HOME/.bashrc"

echo "$(date -u '+%S.%N') .bash_profile finished" >> /Users/aarjomandkhah/jeff.log
