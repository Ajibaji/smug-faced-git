#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

monitor=$(aerospace list-monitors --focused --format "%{monitor-appkit-nsscreen-screens-id}")

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="$INFO" display=$monitor
  sketchybar --set chevron icon="" display=$monitor
fi
