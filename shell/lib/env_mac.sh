# MAC only stuff to extend env.sh

# BAT
  export BAT_CMD="bat"

# BREW
# this file is sourced BEFORE .bashrc or .zshrc so brew is not in
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export HOMEBREW_BUNDLE_FILE=${HOME}/.config/brew/Brewfile
    eval "$(/opt/homebrew/bin/brew shellenv)"
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
  export PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH"
