source "$HOME/.config/shell/lib/colours.sh"

# COLOURS
  export COLORTERM='truecolor'

# THEME SWITCHER
  function set-session-theme () {
    export BAT_THEME_VAR_NAME=BAT_THEME_${CURRENT_THEME}
    export BAT_THEME="${!BAT_THEME_VAR_NAME}"

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

  function set-herdr-pane-theme () {
    if [[ "$(pgrep -q herdr; echo $?)" == "0" ]]; then
      for paneId in $(herdr pane list | jq -r '.result.panes[].pane_id'); do
        if [[ "$(herdr pane process-info --pane $paneId | jq -r '.result.process_info.foreground_processes[0].name')" == "nvim" ]]; then
          herdr pane send-keys $paneId esc
          herdr pane send-text $paneId ":lua utils.tt($nvimTheme)"
        else
          herdr pane send-text $paneId "get-current-theme"
        fi
        herdr pane send-keys $paneId enter
      done
    fi
  }

  function set-os-theme () {
    if [[ "$OS" == "MacOS" ]]; then
      osascript -l JavaScript -e "Application('System Events').appearancePreferences.darkMode = $@"  > /dev/null 2>&1
    else
      echo "Not yet implemented for this linux DE - $OS"
    fi
  }

  function set-kitty-theme () {
    local kitty_cmd=''
    local socket=''
    if [[ -n "$KITTY_PID" ]]; then
      kitty_cmd='kitty'
    else
      kitty_cmd='/Applications/kitty.app/Contents/MacOS/kitty'
      socket="--to unix:$(find /tmp/ -name 'mykitty-*')"
    fi
    $kitty_cmd @ ls $socket | jq -r '.[].tabs.[].windows.[] | select(.at_prompt == true).id' | while read -r window_id; do
      $kitty_cmd @ send-key $socket --match id:$window_id ctrl+c
      $kitty_cmd @ send-text $socket --match id:$window_id "get-current-theme"
      $kitty_cmd @ send-key $socket --match id:$window_id enter
    done
  }

  export -f set-kitty-theme

  function set-terminal-theme () {
    if [[ "$OS" == "MacOS" ]]; then
      if [[ "$(pgrep -i ghostty >/dev/null; echo $?)" == "0" ]]; then
        osascript $HOME/.config/MacOS/ghostty.applescript   # update env vars for every active ghostty terminal session
      fi
      if [[ "$(pgrep -i kitten >/dev/null; echo $?)" == "0" ]]; then
        set-kitty-theme
      fi
    else
      echo "Not yet implemented for this linux DE - $OS"
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
    set-terminal-theme
    set-herdr-pane-theme
    # wait
  }
