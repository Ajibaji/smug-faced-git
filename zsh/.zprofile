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


# FNM - FASTER LOADING NVM REPLACEMENT
  export PATH="/home/pi/.local/share/fnm:$PATH"
  eval "`fnm env`"

# NVM
  alias nvm='fnm $@'

# SSH AGENT
  #eval `ssh-agent`

# DISABLE PHOTOS BACKGROUND ANALYSIS
  #if [ $(pgrep photoanalysisd) ]
  #then
  #    launchctl disable user/$UID/com.apple.photoanalysisd && launchctl kill -TERM user/$UID/com.apple.photoanalysisd
  #    pkill photoanalysisd
  #    sudo mv /System/Library/LaunchAgents/com.apple.photoanalysisd.plist ~/Documents/com.apple.photoanalysisd.plist.$(date -u '+%Y-%m-%dBACKUP')
  #fi

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

export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
