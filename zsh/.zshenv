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

echo "$(date -u '+%S.%N') .zshenv started" >> $HOME/jeff.log

# COLOURS
  export LIGHT_ZSH_AUTOSUGGEST_HL_STYLE='fg=248'
  export DARK_ZSH_AUTOSUGGEST_HL_STYLE='fg=236'

# Setting PATH for Python 3.13
# The original version is saved in .zprofile.pysave
  # export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:${PATH}"
  # export PATH="${HOME}/Library/Python/3.13/bin:${PATH}"

# MORE
  source "$HOME/.cargo/env"

  source "$HOME/.config/shell/env.sh"
  source "$HOME/.config/shell/lib/aliases.sh"

# fnm
  echo "$(date -u '+%S.%N') fnm started" >> $HOME/jeff.log
  eval "`fnm env`"
  echo "$(date -u '+%S.%N') fnm finshed" >> $HOME/jeff.log

echo "$(date -u '+%S.%N') .zshenv finished" >> $HOME/jeff.log
