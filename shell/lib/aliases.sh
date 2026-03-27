# =======================================================================================
# This file contains shell agnostic aliases for sourcing into a shell's .*rc file
# =======================================================================================

if [[ "$OS" == "MacOS" ]]; then
  # GRAM
    alias gram='/Applications/Gram.app/Contents/MacOS/cli'
    alias g='gram'
fi

# AZURE CLI ALIASES
  alias azi='az interactive'

# BAT ALIASES
  alias cat='bat -pp'

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

# NEOVIM
  alias vim='v'

# NEOVIDE (simlink serves unmanagable OS window...this is the workaround)
  # alias neovide='/Applications/Neovide.app/Contents/MacOS/neovide'

# NVM
  alias nvm='fnm'

# TOGGLE-THEME
  alias tt='toggle-theme'

# WHIPTAIL
  # alias whiptail='dialog'
