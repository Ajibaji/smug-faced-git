#!/usr/bin/env bash

function add_aerospace_item() {
  sketchybar --add event aerospace_workspace_change

  aerospace list-monitors --format "%{monitor-id} %{monitor-appkit-nsscreen-screens-id}" | while read -r aero_monitor sb_monitor; do
    for sid in $(aerospace list-workspaces --monitor $aero_monitor); do
      sketchybar --add event aerospace_move_workspace_$sid \
                 --add item space."$sid" left \
                 --subscribe space."$sid" aerospace_workspace_change aerospace_move_workspace_$sid  \
                 --set space."$sid" \
                       display=$sb_monitor \
                       label="$sid" \
                       background.color="$(get_colour ORANGE 90)" \
                       background.corner_radius=10 \
                       background.height=24 \
                       background.drawing=off \
                       padding_left=0 \
                       padding_right=0 \
                       script="$PLUGIN_DIR/aerospace.sh 'space.$sid' '$sb_monitor' '$AEROSPACE_STARTING_WORKSPACE'" \
                       click_script="aerospace workspace $sid"
    done
  done

  sketchybar --add bracket space_items '/space\.*/' \
      --set space_items \
          background.color="$(get_colour BLACK 40)" \
          background.corner_radius=10 \
          background.height=26 \
          background.drawing=on
  }
}
