#! /usr/bin/env bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Custom Window Size
# @raycast.mode silent
# @raycast.packageName System

# Optional parameters:
# @raycast.icon images/custom-window-size.png

# Documentation:
# @raycast.author Ammar
# @raycast.authorURL https://github.com/ajibaji
# @raycast.description Resize frontmost window to fill screen without overlapping top status/menu bar (35px). A workaround for apps using MacOS' native tabs

targetMonitor="$(aerospace list-windows --format '%{monitor-name}' --focused)"
[[ "$targetMonitor" = "Built-in Retina Display" ]] && targetMonitor="Color LCD"
targetApp="$(aerospace list-windows --format '%{app-name}' --focused)"
resolution="$(system_profiler -json SPDisplaysDataType | jq -r --arg monitor "$targetMonitor" '.SPDisplaysDataType[].spdisplays_ndrvs[] | select(._name == $monitor)._spdisplays_resolution')"
width=$(echo $resolution | awk '{print $1}')
height=$(echo $resolution | awk '{print $3}')


osascript -e 'tell application "System Events" to tell application process "'$targetApp'" to set position of window 1 to {5, 40}'
osascript -e 'tell application "System Events" to tell application process "'$targetApp'" to set size of window 1 to {('$width' - 10), ('$height' - 35 - 10)}'

echo "I love...lamp"
