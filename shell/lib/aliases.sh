# =======================================================================================
# This file contains shell agnostic aliases for sourcing into a shell's .*rc file
# =======================================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then
  # gnu-* utils
    alias sed='gsed'
    alias tar='gtar'
    # alias time='gtime' -- BRAKES BLE.SH

  # COREUTILS
  # created with:
  #   `find * -type f -iname 'g*' -exec bash -c 'echo {}' \; | cut -c2- | gxargs --replace=cmm echo "alias cmm='gcmm'"`
    # alias [='g[' -- DO NOT USE
    alias b2sum='gb2sum'
    alias base32='gbase32'
    alias base64='gbase64'
    alias basename='gbasename'
    alias basenc='gbasenc'
    alias cat='gcat'
    alias chgrp='gchgrp'
    alias chmod='gchmod'
    alias chown='gchown'
    alias chroot='gchroot'
    alias cksum='gcksum'
    alias comm='gcomm'
    alias cp='gcp'
    alias csplit='gcsplit'
    alias cut='gcut'
    alias date='gdate'
    alias dd='gdd'
    alias df='gdf'
    alias dir='gdir'
    alias dircolors='gdircolors'
    alias dirname='gdirname'
    alias du='gdu'
    alias echo='gecho'
    alias env='genv'
    alias expand='gexpand'
    alias expr='gexpr'
    alias factor='gfactor'
    alias false='gfalse'
    alias fmt='gfmt'
    alias fold='gfold'
    alias groups='ggroups'
    alias head='ghead'
    alias hostid='ghostid'
    alias id='gid'
    alias install='ginstall'
    alias join='gjoin'
    alias kill='gkill'
    alias link='glink'
    alias ln='gln'
    alias logname='glogname'
    alias ls='gls'
    alias md5sum='gmd5sum'
    alias mkdir='gmkdir'
    alias mkfifo='gmkfifo'
    alias mknod='gmknod'
    alias mktemp='gmktemp'
    alias mv='gmv'
    alias nice='gnice'
    alias nl='gnl'
    alias nohup='gnohup'
    alias nproc='gnproc'
    alias numfmt='gnumfmt'
    alias od='god'
    alias paste='gpaste'
    alias pathchk='gpathchk'
    alias pinky='gpinky'
    alias pr='gpr'
    alias printenv='gprintenv'
    alias printf='gprintf'
    alias ptx='gptx'
    alias pwd='gpwd'
    alias readlink='greadlink'
    alias realpath='grealpath'
    alias rm='grm'
    alias rmdir='grmdir'
    alias seq='gseq'
    alias sha1sum='gsha1sum'
    alias sha224sum='gsha224sum'
    alias sha256sum='gsha256sum'
    alias sha384sum='gsha384sum'
    alias sha512sum='gsha512sum'
    alias shred='gshred'
    alias shuf='gshuf'
    alias sleep='gsleep'
    alias sort='gsort'
    alias split='gsplit'
    alias stat='gstat'
    alias stdbuf='gstdbuf'
    alias stty='gstty'
    alias sum='gsum'
    alias sync='gsync'
    alias tac='gtac'
    alias tail='gtail'
    alias tee='gtee'
    alias test='gtest'
    alias timeout='gtimeout'
    alias touch='gtouch'
    alias tr='gtr'
    alias true='gtrue'
    alias truncate='gtruncate'
    alias tsort='gtsort'
    alias tty='gtty'
    alias uname='guname'
    alias unexpand='gunexpand'
    alias uniq='guniq'
    alias unlink='gunlink'
    alias uptime='guptime'
    alias users='gusers'
    alias vdir='gvdir'
    alias wc='gwc'
    alias who='gwho'
    alias whoami='gwhoami'
    alias yes='gyes'

fi

# AZURE CLI ALIASES
  alias azi='az interactive'

# BAT ALIASES
  alias cat='batcat -pp'
  if [[ "$OSTYPE" == "darwin"* ]]; then
    alias batcat='bat'
  else
    alias bat='batcat'
  fi

# DOCKER ALIASES
  # alias docker='lima nerctl'
  alias dokcer='docker'
  alias dockre='docker'
  alias dokcre='docker'

# DOS-style clear-screen
  alias cls='clear -x'
  # alias clear='clear -x'

# GIT ALIASES
  alias git='git --config-env=delta.features=CURRENT_THEME'
  alias gst='git status'
  alias gco='git checkout'

# KUBERNETES ALIASES
  alias kk='kubectl'

# LAZY-GIT/GITUI
  alias lg="lazygit"
  # alias lg="gitui -t ${CURRENT_THEME}-theme.ron"

# NEOVIM
  alias v='nvim'
  alias vim='v'

# NEOVIDE (simlink serves unmanagable OS window...this is the workaround)
  # alias neovide='/Applications/Neovide.app/Contents/MacOS/neovide'

# NVM
  alias nvm='fnm'

# TOGGLE-THEME
  alias tt='toggle-theme'

# WHIPTAIL
  # alias whiptail='dialog'
