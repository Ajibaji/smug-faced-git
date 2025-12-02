echo "$(date -u '+%S.%N') .zshrc started" >> $HOME/jeff.log
# =======================================================================================
# This file gets read when an interative shell is opened
# ———————————————————————————————————————————————————————————————————————————————————————
# load order:
# .zshenv → .zprofile → .ZSHRC → .zlogin → .zlogout
# ———————————————————————————————————————————————————————————————————————————————————————
# use this file to set everything needed for interactive usage. e.g:
#  - prompt formatting
#  - command completion
#  - output formatting
#  - user-usable aliases/functions
#  - history management
# =======================================================================================

#_________________________________________________________________________________ROOT-RC:
    source "$HOME/.config/zsh/.zshroot"

#_______________________________________________________________________AUTO-ADDED-CONFIG:

# fzf
echo "$(date -u '+%S.%N') fzf started" >> $HOME/jeff.log
source <(fzf --zsh)
echo "$(date -u '+%S.%N') fzf finished" >> $HOME/jeff.log


# Zoxide
echo "$(date -u '+%S.%N') zoxide started" >> $HOME/jeff.log
eval "$(zoxide init zsh)"
echo "$(date -u '+%S.%N') zoxide finshed" >> $HOME/jeff.log
echo "$(date -u '+%S.%N') .zshrc finished" >> $HOME/jeff.log
