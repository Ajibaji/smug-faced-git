export BASH_RC_LOADED="true"

# load ~/.bash_profile if entrypoint was ~/.bashrc
[ -z "$BASH_PROFILE_LOADED" ] && source "$HOME/.bash_profile"
unset BASH_PROFILE_LOADED

#_____________________________________________________________________________________FNM:
  [[ "$OS" != "NixOS" ]] && eval "$(fnm env)"


#_______________________________________________________________________________TTY-CHECK:
# if not running interactively, do nothing
[ -z "$PS1" ] && return

#______________________________________________________________FUNCTIONS_&_THEME_SWITCHER:
  source "$HOME/.config/shell/salad-source.sh"


#__________________________________________________________________________________PROMPT:
  source "$HOME/.config/bash/lib/prompt.sh"


#_____________________________________________________________________________________RUN:
  if [[ "$PWD" == "/mnt/"* ]]; then
    cd $HOME
  fi


#_____________________________________________________________________________________FZF:
  source <(fzf --bash)


#_________________________________________________________________________________HISTORY:
  # load this AFTER fzf
  source "$HOME/.config/bash/lib/history.sh"
  bind -x '"\C-r": shell_history_search'


#_________________________________________________________________________BASH-COMPLETION:
  if [[ -s $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]]; then
    . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
  fi


#__________________________________________________________________________________ZOXIDE:
  eval "$(zoxide init bash)"
