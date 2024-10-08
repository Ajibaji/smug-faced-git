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
