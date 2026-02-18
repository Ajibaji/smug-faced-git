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

# MACOS VALUES
# =======================================================================================
  if [[ "$OSTYPE" == "darwin"* ]]; then
    source $HOME/.config/shell/lib/env_mac.sh
  fi

# MAN
  export MANPAGER="bash -c 'col -bx | bat -l man -p'"

# WSL VALUES
# =======================================================================================
# Disabling this while WSLg is in use over VcXsrv
# if [[ -n "${WSL_DISTRO_NAME}" ]]; then
#   export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0
# fi

# CONCATENATED VALUES
# =======================================================================================

# AWS CREDENTIALS
  export AWS_SHARED_CREDENTIALS_FILE=${HOME}/.aws/credentials

# AZURE
  export VSO_AGENT_IGNORE=PIPELINE_AGENT_TOKEN,USER,AWS_SHARED_CREDENTIALS_FILE,API_TOKEN

# DOTNET
  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# EGET
  export EGET_BIN=$HOME/.local/eget/bin
  [[ ! -d $EGET_BIN ]] && mkdir -p $EGET_BIN
  export PATH=$EGET_BIN:$PATH

# FZF
  export FZF_COMMON_OPTS='--info=hidden --reverse --exact --height=50% -m --prompt="  " --pointer=">" --marker="+"'

# GCC
  export CXXFLAGS="-Wno-format-security"
  export CFLAGS="-Wno-format-security"

# GO
  export GOPATH=${HOME}/go
  export GOROOT=/usr/local/go
  export GOBIN=${GOPATH}/bin
  export PATH=$PATH:${GOROOT}:${GOBIN}

# KUBERNETES
  export PATH=$PATH:${HOME}/.kube/plugins/jordanwilson230

# Nodejs
  [[ -f $CUSTOM_CA_CERTS ]] && export NODE_EXTRA_CA_CERTS=${CUSTOM_CA_CERTS}

# PERSONAL BIN
  # export PATH=$PATH:${HOME}/Documents/code/ME/bin
  export PATH="${HOME}/work/other/tools-and-snippets/bin:${PATH}"

# PYTHON
  [[ -f $CUSTOM_CA_CERTS ]] && export REQUESTS_CA_BUNDLE=${CUSTOM_CA_CERTS}
  export PYENV_ROOT="$HOME/.pyenv"
  [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init - bash)"

# Ruby
  [[ -f $CUSTOM_CA_CERTS ]] && export SSL_CERT_FILE=${CUSTOM_CA_CERTS}

# GRADLE
  # export GRADLE_HOME=$HOME/Downloads/gradle
  # export PATH=$GRADLE_HOME/bin:$PATH


#_________________________________________________________________________________ALIASES:
    source "$HOME/.config/shell/lib/aliases.sh"

