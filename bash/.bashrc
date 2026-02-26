# if not running interactively, do nothing
[ -z "$PS1" ] && [ -z $BOATING_JEFF ] && return

# load ~/.bash_profile if entrypoint was ~/.bashrc
export BASH_RC_LOADED="true"
[ -z "$BASH_PROFILE_LOADED" ] && source "$HOME/.bash_profile"


#______________________________________________________________FUNCTIONS_&_THEME_SWITCHER:
  source "$HOME/.config/shell/salad-source.sh"


#__________________________________________________________________________________PROMPT:
  source "$HOME/.config/bash/lib/prompt.sh"


#_____________________________________________________________________________________RUN:
  if [[ "$PWD" == "/mnt/"* ]]; then
    cd $HOME
  fi


#___________________________________________________________________________________ATUIN:
#   test $(uname -s) = "Linux" && export PATH="$HOME/.atuin/bin:$PATH"
#   eval "$(atuin init bash)"


#_____________________________________________________________________________________FZF:
  source <(fzf --bash)


#_____________________________________________________________________________________FNM:
  [[ "$OS" != "NixOS" ]] && eval "$(fnm env)"


#___________________________________________________________________________________PYENV:
  [[ "$OS" != "NixOS" ]] && eval "$(pyenv init - bash)"


#__________________________________________________________________________________ZOXIDE:
  eval "$(zoxide init bash)"
