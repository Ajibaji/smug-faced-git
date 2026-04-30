# MAC only stuff to extend env.sh

# BAT
  export BAT_CMD="bat"

# BREW
# this file is sourced BEFORE .bashrc or .zshrc so brew is not in
  if [[ "$OS" == "MacOS" ]]; then
    export HOMEBREW_BUNDLE_FILE=${HOME}/.config/brew/Brewfile
    # instead of time-consuming `brew shellenv`:
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    eval "$(/usr/bin/env PATH_HELPER_ROOT="/opt/homebrew" /usr/libexec/path_helper -s)"
    [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
  fi

# CA-Certs
  export CUSTOM_CA_CERTS="/opt/homebrew/etc/ca-certificates/cert.pem"

# Java
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home"

# Ruby
  export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
  export PATH="$(gem environment gempath):$PATH"

# X11
  export DISPLAY=:0
#  export PATH=$PATH:/usr/X11R6/bin

# KEEP THIS LAST
  # export PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH"
  export PATH="$HOME/Library/Python/3.13/bin:$PATH"
