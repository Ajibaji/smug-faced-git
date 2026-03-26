#! /usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Toggle Theme
# @raycast.mode silent
# @raycast.packageName ToggleTheme

# Documentation:
# @raycast.author Ammar
# @raycast.authorURL https://github.com/ajibaji
# @raycast.description Toggle theme and update all running nvim and ghostty sessions

# TRIGGER: key combo
#  ACTION: does the following this order:
#            - toggle theme at OS-level
#            - toggle theme in all current nvim sessions
#            - update all theme-related env-vars in all current ghostty terminals

source "$HOME/.config/shell/lib/theme.sh"
toggle-theme
