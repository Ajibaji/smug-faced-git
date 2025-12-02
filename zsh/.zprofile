echo "$(date -u '+%S.%N') .zprofile started" >> $HOME/jeff.log
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
# in MacOS, PATH variables must be set here for interactive and non-interactive shells
# this is because MacOS has a helper utility that runs before .zprofile and re-orders PATH
# entries
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
echo "$(date -u '+%S.%N') .zprofile finshed" >> $HOME/jeff.log
