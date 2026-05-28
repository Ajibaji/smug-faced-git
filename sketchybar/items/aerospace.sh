#!/usr/bin/env bash

mapfile -t WORKSPACE_MONITOR_MAPPINGS < <( aerospace list-workspaces --all --format "%{workspace}:%{monitor-appkit-nsscreen-screens-id}" )

label_for_ws() {
    case "$1" in
        1) echo "Teams";;
        2) echo "Web";;
        3) echo "Shell";;
        4) echo "Remote";;
        5) echo "Misc";;
        6) echo "Meeting";;
        *) echo "$1";;
    esac
}

for MAPPING in "${WORKSPACE_MONITOR_MAPPINGS[@]}"; do
    workspace=$(echo ${MAPPING} | cut -d: -f1)
    monitor=$(echo ${MAPPING} | cut -d: -f2)

    sketchybar --add item space.$monitor.$workspace left \
        --set space.$monitor.$workspace \
            label="$(label_for_ws $workspace)" \
            background.color="$(get_colour ORANGE 90)" \
            background.drawing=off \
            click_script="aerospace workspace $workspace" \
            script="$PLUGIN_DIR/aerospace.sh $monitor $workspace"\
        --subscribe space.$monitor.$workspace aerospace_workspace_change display_change
done

sketchybar --add bracket space_items '/space\.*/' \
    --set space_items \
        # background.color="$(get_colour BLACK 40)" \
        # background.corner_radius=12 \
        # background.height=28 \
        background.drawing=on
}
