# =======================================================================================
# This file gets read every time (including non-interactive shells e.g. `launchd`)
# ———————————————————————————————————————————————————————————————————————————————————————
# load order:
# .ZSHENV → .zprofile → .zshrc → .zlogin → .zlogout
# ———————————————————————————————————————————————————————————————————————————————————————
# use this file to set:
#  - frequently updated ENV VARS e.g. PATH
#  - machine-usable aliases/functions
# =======================================================================================

# COLOURS
  export LIGHT_ZSH_AUTOSUGGEST_HL_STYLE='fg=248'
  export DARK_ZSH_AUTOSUGGEST_HL_STYLE='fg=236'
  source ${HOME}/.config/shell/env.sh
