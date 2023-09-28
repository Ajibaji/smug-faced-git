# =======================================================================================
# This file gets read at login
# ———————————————————————————————————————————————————————————————————————————————————————
# load order:
# .zshenv → .ZPROFILE → .zshrc → .zlogin → .zlogout
# ———————————————————————————————————————————————————————————————————————————————————————
# use this file for commands and variables which should be set once or which don't 
# need to be updated frequently. e.g:
#  - environment variables to configure tools
#  - configuration which executes commands (as it may take some time to execute)
# =======================================================================================

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo ""
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source ${HOME}/.config/zsh/.zshprofile_mac
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
else
  echo "Unknown OS" 
fi

# FNM - FASTER LOADING NVM REPLACEMENT
  export PATH="${HOME}/.local/share/fnm:$PATH"
  eval "`fnm env`"

# NVM
  alias nvm='fnm $@'

# auto-suggestions (now included under ~/.config/zsh/.zhistory)
    # source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Command history
    HISTFILE=$HOME/.zsh_history
    HISTSIZE=2000
    SAVEHIST=5000
    setopt EXTENDED_HISTORY
    setopt SHARE_HISTORY
    setopt APPEND_HISTORY
    setopt INC_APPEND_HISTORY
    setopt HIST_VERIFY

# fuzzy finder
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
