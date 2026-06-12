#!/usr/bin/env bash

sid="$1"
monitor="$2"
starting_workspace="$3"

if [[ "$SENDER" == "forced" ]]; then
  [[ "$NAME" == "space.$starting_workspace" ]] && highlight_item=on
  sketchybar --set "$NAME" \
                   background.drawing=$highlight_item
fi

if [[ "$SENDER" == "aerospace_move_workspace"* ]]; then
  sketchybar --set "$NAME" \
                   display="$INFO"
fi

if [[ "$SENDER" == "aerospace_workspace_change" ]]; then
  highlight_item=off
  [[ "$sid" == "$FOCUSED" ]] && highlight_item=on
  sketchybar --set "$NAME" \
                   background.drawing=$highlight_item
fi
