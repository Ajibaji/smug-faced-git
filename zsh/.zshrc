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

# fnm
eval "`fnm env`"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Zoxide
eval "$(zoxide init zsh)"
