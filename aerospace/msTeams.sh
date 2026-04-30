#! /usr/bin/env bash

# TRIGGER: aerospace detects a microsoft teams window being opened in the "teams" workspace
#  ACTION: count Microsoft Teams windows in the "Teams" workspace. can be 1 or 2 only.
#          if one do nothing. if two, move newer window to the "Meeting" workspace.

function moveWindowToWorkspace() {
    local windowId=$1
    local workspaceName=$2

    aerospace move-node-to-workspace --window-id "$windowId" "$workspaceName" --focus-follows-window
}

function resizeWindow() {
    local windowId=$1
    local targetSize=$2
    local workspace=$3

    targetMonitor=$(aerospace list-windows --format '%{monitor-name}' --workspace $workspace | head -1)
    screenWidth=$(system_profiler -json SPDisplaysDataType | jq -r --arg monitor "$targetMonitor" '.SPDisplaysDataType[].spdisplays_ndrvs[] | select(._name == $monitor)._spdisplays_resolution' | awk '{print $1}')
    targetPixelWidth=$(awk "BEGIN {printf \"%.0f \", $screenWidth*0.$targetSize}")

    aerospace resize --window-id $windowId width $targetPixelWidth
}

teamsWindows=$(aerospace list-windows --app-bundle-id "com.microsoft.teams2" --monitor all --format '%{window-id}')
windowCount=$(echo "$teamsWindows" | wc -w  | tr -d '[:space:]')
newWindow=$(echo "$teamsWindows" | sort -nr | head -1)

case $windowCount in
    1)
        moveWindowToWorkspace "$newWindow" Teams
        ;;
    2)
        moveWindowToWorkspace "$newWindow" Meeting
        ;;
    3)
        moveWindowToWorkspace "$newWindow" Meeting
        resizeWindow "$newWindow" 75 Meeting
        ;;
    4)
        moveWindowToWorkspace "$newWindow" Meeting
        aerospace balance-sizes --workspace Meeting
        resizeWindow "$newWindow" 50 Meeting
        ;;
    *)
        exit 0
        ;;
esac
