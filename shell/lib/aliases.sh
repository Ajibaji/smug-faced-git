# =======================================================================================
# This file contains shell agnostic aliases for sourcing into a shell's .*rc file
# =======================================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then
    # SED
      alias sed='gsed'
fi

    # BAT ALIASES
      # alias cat='bat --paging=never'

    # DOCKER ALIASES
      # alias docker='lima nerctl'
      alias dokcer='docker $@'
      alias dockre='docker $@'
      alias dokcre='docker $@'

    # DOS-style clear-screen
      alias cls='clear'

    # GIT ALIASES
      alias gst='git status'
      alias gco='git checkout $@'

    # KUBERNETES ALIASES
      alias kk='kubectl $@'

    # LAZY-GIT/GITUI
      alias lg="lazygit"
      # alias lg="gitui -t ${CURRENT_THEME}-theme.ron"

    # NEOVIM
      alias v='nvim'
      alias vim='v'

    # NEOVIDE (simlink serves unmanagable OS window...this is the workaround)
      # alias neovide='/Applications/Neovide.app/Contents/MacOS/neovide'

    # NVM
      alias nvm='fnm $@'

    # TOGGLE-THEME
      alias tt='toggle-theme'

    # WHIPTAIL
      # alias whiptail='dialog'
