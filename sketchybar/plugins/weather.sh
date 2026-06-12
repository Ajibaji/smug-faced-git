#!/usr/bin/env bash

weather="$(curl wttr.in/wandsworth?format=1 2>/dev/null | sed 's/ +//g')"
sketchybar --set "$NAME" label="$weather"
