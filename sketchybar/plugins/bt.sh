#!/usr/bin/env bash

DEVICES="$(system_profiler SPBluetoothDataType -json -detailLevel basic 2>/dev/null | jq '.SPBluetoothDataType' | jq '.[0].device_connected' | grep 'Headset')"

if [ "$DEVICES" = "" ]; then
  sketchybar -m --set headphones drawing=off
else
  sketchybar -m --set headphones drawing=on
fi
