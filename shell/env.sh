# =======================================================================================
# use this file to set:
#  - frequently updated ENV VARS e.g. PATH
# =======================================================================================

# BASE VALUES TO BE OVERWRITTEN BY OS-SPECIFIC VALUES (IF PRESENT)
# =======================================================================================

# -------
  export EDITOR=nvim

# CA-certs
  [[ -f $CUSTOM_CA_CERTS ]] && export CUSTOM_CA_CERTS="${HOME}/CustomCA.pem"

# MAN
  export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# WSL VALUES
# =======================================================================================
if [[ -n "${WSL_DISTRO_NAME}" ]]; then
  export KITTY_DISABLE_WAYLAND=1
  export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
fi

# MACOS VALUES
# =======================================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
  source ${HOME}/.config/shell/lib/env_mac.sh
fi

# CONCATENATED VALUES
# =======================================================================================

# AWS CREDENTIALS
  export AWS_SHARED_CREDENTIALS_FILE=~/.aws/credentials

# AZURE
  export VSO_AGENT_IGNORE=PIPELINE_AGENT_TOKEN,USER,AWS_SHARED_CREDENTIALS_FILE,API_TOKEN

# DOTNET
  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# FZF
  export FZF_COMMON_OPTS='--info=hidden --reverse --exact --height=50% -m --prompt="  " --pointer=">" --marker="+"'

# GCC
  export CXXFLAGS="-Wno-format-security"
  export CFLAGS="-Wno-format-security"

# KUBERNETES
  export PATH=$PATH:~/.kube/plugins/jordanwilson230

# Nodejs
  [[ -f $CUSTOM_CA_CERTS ]] && export NODE_EXTRA_CA_CERTS=${CUSTOM_CA_CERTS}

# PERSONAL BIN
  # export PATH=$PATH:~/Documents/code/ME/bin
  export PATH=$PATH:~/work/other/tools-and-snippets/bin

# PYTHON
  [[ -f $CUSTOM_CA_CERTS ]] && export REQUESTS_CA_BUNDLE=${CUSTOM_CA_CERTS}

# Ruby
  [[ -f $CUSTOM_CA_CERTS ]] && export SSL_CERT_FILE=${CUSTOM_CA_CERTS}

# COLOURS
  export COLORTERM='truecolor'
  # export LIGHT_FZF_DEFAULT_OPTS="--color=fg:#cb719d,bg:#e6dfd6,hl:#5f87af --color=fg+:#575277,bg+:#e6dfd6,hl+:#5f87af --color=info:#afaf87,prompt:#d7005f,pointer:#d7005f --color=marker:#af5fff,spinner:#5cdeff,header:#87afaf"
  # export DARK_FZF_DEFAULT_OPTS="--color=fg:#967a87,bg:#203042,hl:#5880a8 --color=fg+:#e8e8e8,bg+:#203042,hl+:#73a6d9 --color=info:#707053,prompt:#994c6d,pointer:#bd7aff --color=marker:#84ff00,spinner:#7f738c,header:#009e9e"
  source ${HOME}/.config/shell/lib/env_colours.sh

# GRADLE
  # export GRADLE_HOME=$HOME/Downloads/gradle
  # export PATH=$GRADLE_HOME/bin:$PATH
