# MAC only stuff to extend env.sh

# BREW
  export HOMEBREW_BUNDLE_FILE=${HOME}/.config/brew/Brewfile
#  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

# Java
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_162.jdk/Contents/Home"

# Python
#  export PATH="/usr/local/opt/python/libexec/bin:$PATH"

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
