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


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  echo ""
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source ${HOME}/.config/zsh/.zshenv_mac
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
else
  echo "Unknown OS" 
fi

# -------
  export EDITOR=nvim

# AWS CREDENTIALS
  export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials

# AZURE
  export VSO_AGENT_IGNORE=PIPELINE_AGENT_TOKEN,USER,AWS_SHARED_CREDENTIALS_FILE,API_TOKEN

# FZF
  export FZF_COMMON_OPTS='--info=hidden --reverse --exact --height=50% -m --prompt="  " --pointer=">" --marker="+"'

# KUBERNETES
  export PATH=$PATH:~/.kube/plugins/jordanwilson230

# MAN
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# PERSONAL BIN
  export PATH=$PATH:~/Documents/code/ME/bin

# COLOURS
  export LIGHT_FZF_DEFAULT_OPTS="$FZF_COMMON_OPTS --color=fg:#cb719d,bg:#e6dfd6,hl:#5f87af --color=fg+:#575277,bg+:#e6dfd6,hl+:#5f87af --color=info:#afaf87,prompt:#d7005f,pointer:#d7005f --color=marker:#af5fff,spinner:#5cdeff,header:#87afaf"
  export DARK_FZF_DEFAULT_OPTS="$FZF_COMMON_OPTS --color=fg:#967a87,bg:#203042,hl:#5880a8 --color=fg+:#e8e8e8,bg+:#203042,hl+:#73a6d9 --color=info:#707053,prompt:#994c6d,pointer:#bd7aff --color=marker:#84ff00,spinner:#7f738c,header:#009e9e"
  export DARK_KITTY_THEME='Nightfox'
  export LIGHT_KITTY_THEME='Dawnfox'
  export LIGHT_ZSH_AUTOSUGGEST_HL_STYLE='fg=248'
  export DARK_ZSH_AUTOSUGGEST_HL_STYLE='fg=236'
  source ${HOME}/.config/zsh/.zshenv_colours

# AUTO-ADDED VALUES
. "$HOME/.cargo/env"
