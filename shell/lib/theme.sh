# THEME SWITCHER
  function set-kitty-theme () {
    kitty +kitten themes --reload-in=all --config-file-name=themes.conf "$KITTY_THEME"
  }

  function set-git-theme () {
    git config --global delta.features "$CURRENT_THEME"
  }

  function set-session-theme () {
    if [[ "$CURRENT_THEME" = "DARK" ]]
    then
      sed -i 's/LIGHT/DARK/gI' ${HOME}/.config/shell/env_colours.sh
    else
      sed -i 's/DARK/LIGHT/gI' ${HOME}/.config/shell/env_colours.sh
    fi
    source ${HOME}/.config/shell/env_colours.sh
  }

  function get-current-theme () {
    defaults read -g AppleInterfaceStyle > /dev/null 2>&1
    if [[ "$?" = "0" ]]
    then
      export CURRENT_THEME=DARK
    else
      export CURRENT_THEME=LIGHT
    fi
    set-session-theme
    set-git-theme
    # set-kitty-theme
  }

  function set-os-theme () {
    if [[ "$OSTYPE" == "darwin"* ]]; then
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
    [ $TERM = 'xterm-kitty' ] && set-kitty-theme
    set-git-theme
    # wait
  }

# RUN
  # SILENT=true aws-env & --------------- takes way too long using aws config and cant be thrown to background as env vars dont get set
  get-current-theme
  [ $TERM = 'xterm-kitty' ] && set-kitty-theme
