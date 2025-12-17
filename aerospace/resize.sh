#! /usr/bin/env bash

targetWorkspace=$1
targetSize=$2

windowList=$(aerospace list-windows --format '%{window-id}' --workspace $targetWorkspace)
targetWindow=$(echo $windowList | awk '{print $2}')
targetMonitor=$(aerospace list-windows --format '%{monitor-name}' --workspace $targetWorkspace | head -1)
screenWidth=$(system_profiler -json SPDisplaysDataType | jq -r --arg monitor "$targetMonitor" '.SPDisplaysDataType[].spdisplays_ndrvs[] | select(._name == $monitor)._spdisplays_resolution' | awk '{print $1}')
targetPixelWidth=$(awk "BEGIN {printf \"%.0f \", $screenWidth*0.$targetSize}")

if [[ $(echo $windowList | wc -w) -eq 2 ]]; then
    aerospace resize --window-id $targetWindow width $targetPixelWidth
fi
