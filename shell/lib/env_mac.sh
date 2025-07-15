# MAC only stuff to extend env.sh

# BREW
# this file is sourced BEFORE .bashrc or .zshrc so brew is not in
  export HOMEBREW_BUNDLE_FILE=${HOME}/.config/brew/Brewfile
  eval "$(/opt/homebrew/bin/brew shellenv)"

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

# GNU - try to keep this last(ish)
#  export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH" # COREUTILS
#  export PATH="/usr/local/opt/binutils/bin:$PATH" # BINUTILS
#  export LDFLAGS="-L/usr/local/opt/binutils/lib" # LD FLAG FOR COMPILER
#  export CPPFLAGS="-I/usr/local/opt/binutils/include" # CPP FLAG FOR COMPILER
#  export PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH" # TAR
#  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH" # SED
#  export PATH="/usr/local/opt/make/libexec/gnubin:$PATH" # MAKE
#  export PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH" # FINDUTILS
