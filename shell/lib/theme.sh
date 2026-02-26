source "$HOME/.config/shell/lib/colours.sh"

# COLOURS
  export COLORTERM='truecolor'

# THEME SWITCHER
  function set-session-theme () {
    export BAT_THEME_VAR_NAME=BAT_THEME_${CURRENT_THEME}
    export BAT_THEME=${!BAT_THEME_VAR_NAME}

    export FZF_COLOURS=${CURRENT_THEME}_FZF_COLOURS
    export FZF_DEFAULT_OPTS="$FZF_COMMON_OPTS ${!FZF_COLOURS}"

    export LG_CONFIG_FILE="$HOME/.config/lazygit/$CURRENT_THEME-config.yml"

    export THEME_ZSH_AUTOSUGGEST_HL_STYLE=${CURRENT_THEME}_ZSH_AUTOSUGGEST_HL_STYLE
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=${!THEME_ZSH_AUTOSUGGEST_HL_STYLE}
  }

  function get-current-theme () {
    if [[ "$OS" == "MacOS" ]]; then
      defaults read -g AppleInterfaceStyle > /dev/null 2>&1
      if [[ "$?" = "0" ]]
      then
        export CURRENT_THEME=DARK
      else
        export CURRENT_THEME=LIGHT
      fi
    else
      export CURRENT_THEME=DARK
    fi
    set-session-theme
  }

  function set-nvim-theme () {
    [[ "$CURRENT_THEME" = "DARK" ]] && nvimTheme=0 || nvimTheme=1
    fd --glob 'nvim.*' \
      --type s \
      /var/folders \
      --exec nvim --remote-send ":lua utils.tt($nvimTheme)<CR>" --server {}
  }

  function set-os-theme () {
    if [[ "$OS" == "MacOS" ]]; then
      osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = $@"
    else
      echo "Not yet implemented for this linux DE"
    fi
  }

  function toggle-theme () {
    get-current-theme
    if [[ "$CURRENT_THEME" = "DARK" ]]
    then
      darkMode="false"
      export CURRENT_THEME=LIGHT
    else
      darkMode="true"
      export CURRENT_THEME=DARK
    fi
    (set-os-theme $darkMode)
    set-session-theme
    set-nvim-theme
    # wait
  }

# RUN
  # SILENT=true aws-env & --------------- takes way too long using aws config and cant be thrown to background as env vars dont get set
  get-current-theme
