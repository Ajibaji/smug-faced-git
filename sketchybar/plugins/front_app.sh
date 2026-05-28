#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

if [ "$SENDER" = "front_app_switched" ]; then
  monitor=$(aerospace list-windows --focused --format "%{monitor-appkit-nsscreen-screens-id}")
  sketchybar --set "$NAME" label="$INFO" associated_display=$monitor
  sketchybar --set chevron icon="" associated_display=$monitor
fi
