#! /usr/bin/env bash

# TRIGGER: key combo
#  ACTION: move focused workspace to next monitor and reload sketchybar.
#          if workspace contains only a single floating window,
#          reposition and resize to fill screen

aerospace move-workspace-to-monitor --wrap-around next
windowsInWorkspace=$(aerospace list-windows --workspace focused --format '%{app-bundle-id} %{window-layout}' | sort -u)
windowsInWorkspaceCount=$(echo $windowsInWorkspace | wc -l)

if [[  $windowsInWorkspaceCount -eq 1 ]] && [[ $( echo $windowsInWorkspace | awk '{print $2}') == 'floating' ]]; then
  aerospace fullscreen
fi

sketchybar --trigger aerospace_move_workspace_$(aerospace list-workspaces --focused) \
  INFO=$(aerospace list-monitors --focused --format "%{monitor-appkit-nsscreen-screens-id}")
