#! /usr/bin/env bash

# TRIGGER: aerospace detects a microsoft teams window being opened in the "teams" workspace

# ACTION: count Microsoft Teams windows in the "Teams" workspace. can be 1 or 2 only.
#         if one do nothing. if two, move newer window to the "Meeting" workspace.

teamsWindows=$(aerospace list-windows --app-bundle-id "com.microsoft.teams2" --workspace Teams --format '%{window-id}')
if [[ $(echo $teamsWindows | wc -w) -gt 1 ]]; then
    secondWindow=$(echo $teamsWindows | awk '{print $2}')
    aerospace move-node-to-workspace --window-id $secondWindow Meeting
    aerospace layout --window-id $secondWindow tiling
else
    aerospace move-node-to-workspace --window-id $teamsWindows Teams
    aerospace layout --window-id $teamsWindows tiling
fi
