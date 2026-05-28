# #!/usr/bin/env bash

MONITOR="$1" # This is from the item name, might be outdated
WORKSPACE="$2"
NUM_MONITORS=$(aerospace list-monitors --count)
VISIBLE_WORKSPACES=""

for i in $(seq 1 $NUM_MONITORS); do
  VISIBLE_WS=$(aerospace list-workspaces --visible --monitor $i)
  VISIBLE_WORKSPACES="$VISIBLE_WORKSPACES $VISIBLE_WS"
done

if [[ " $VISIBLE_WORKSPACES " == *" $WORKSPACE "* ]]; then
  sketchybar --set "$NAME" background.drawing=on
else
  sketchybar --set "$NAME" background.drawing=off
fi

if [ "$(echo $NAME | cut -d. -f2)" != "$MONITOR" ]; then
  sketchybar --rename "$NAME" "space.${MONITOR}.${WORKSPACE}"
fi

sketchybar --set "$NAME" associated_display=$MONITOR
