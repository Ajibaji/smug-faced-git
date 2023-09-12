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

# -------
  export EDITOR=nvim
  
# AWS CREDENTIALS
  export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials

# AZURE
  export VSO_AGENT_IGNORE=PIPELINE_AGENT_TOKEN,USER,AWS_SHARED_CREDENTIALS_FILE,API_TOKEN

# AZURE
  export HOMEBREW_BUNDLE_FILE=${HOME}/.config/brew/Brewfile
# FZF
  # export FZF_COMMON_OPTS='--reverse --border --exact --height=50%'
  export FZF_COMMON_OPTS='--info=hidden --exact --height=50% --margin=10%,5%,8%,5% -m --prompt="   > " --pointer=">" --marker="+"'

# Java
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home"

# KUBERNETES
  export PATH=$PATH:~/.kube/plugins/jordanwilson230

# LAZYGIT
  export LG_CONFIG_FILE=~/.config/lazygit/config.yml

# MAN
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Python
  export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# PERSONAL BIN
  export PATH=$PATH:~/Documents/code/ME/bin

# X11
  export DISPLAY=:0
  export PATH=$PATH:/usr/X11R6/bin

# GNU - try to keep this last(ish)
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" # COREUTILS
  export PATH="/usr/local/opt/binutils/bin:$PATH" # BINUTILS
  export LDFLAGS="-L/usr/local/opt/binutils/lib" # LD FLAG FOR COMPILER
  export CPPFLAGS="-I/usr/local/opt/binutils/include" # CPP FLAG FOR COMPILER
  export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH" # TAR
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH" # SED
  export PATH="/usr/local/opt/make/libexec/gnubin:$PATH" # MAKE
  export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH" # FINDUTILS

# BREW
  export PATH="/usr/local/sbin:$PATH"

# COLOURS
  export LIGHT_FZF_DEFAULT_OPTS="$FZF_COMMON_OPTS --color=fg:#cb719d,bg:#e6dfd6,hl:#5f87af --color=fg+:#575277,bg+:#e6dfd6,hl+:#5f87af --color=info:#afaf87,prompt:#d7005f,pointer:#d7005f --color=marker:#af5fff,spinner:#5cdeff,header:#87afaf"
  export DARK_FZF_DEFAULT_OPTS="$FZF_COMMON_OPTS --color=fg:#967a87,bg:#203042,hl:#5880a8 --color=fg+:#e8e8e8,bg+:#203042,hl+:#73a6d9 --color=info:#707053,prompt:#994c6d,pointer:#bd7aff --color=marker:#84ff00,spinner:#7f738c,header:#009e9e"
  export DARK_KITTY_THEME='Nightfox'
  export LIGHT_KITTY_THEME='Dawnfox'
  export LIGHT_ZSH_AUTOSUGGEST_HL_STYLE='fg=248'
  export DARK_ZSH_AUTOSUGGEST_HL_STYLE='fg=236'

  source ${HOME}/.config/zsh/.zshenv_colours

. "$HOME/.cargo/env"
