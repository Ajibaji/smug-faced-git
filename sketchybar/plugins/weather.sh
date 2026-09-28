#!/usr/bin/env bash

# weather="$(curl wttr.in/wandsworth?format=1 2>/dev/null | sed 's/ +//g')"
# sketchybar --set "$NAME" label="$weather"

weather=$(curl -s 'https://api.open-meteo.com/v1/forecast?latitude=51.45468&longitude=-0.159232&current=temperature_2m,weather_code,is_day' | jq -r '                                                    {
    "0":  {"day":"☀️","night":"🌙"},
    "1":  {"day":"🌤️","night":"🌙"},
    "2":  {"day":"⛅","night":"☁️"},
    "3":  {"day":"☁️","night":"☁️"},
    "45": {"day":"🌫️","night":"🌫️"},
    "48": {"day":"🌫️","night":"🌫️"},
    "51": {"day":"🌦️","night":"🌧️"},
    "53": {"day":"🌦️","night":"🌧️"},
    "55": {"day":"🌦️","night":"🌧️"},
    "61": {"day":"🌧️","night":"🌧️"},
    "63": {"day":"🌧️","night":"🌧️"},
    "65": {"day":"🌧️","night":"🌧️"},
    "71": {"day":"🌨️","night":"🌨️"},
    "73": {"day":"🌨️","night":"🌨️"},
    "75": {"day":"🌨️","night":"🌨️"},
    "80": {"day":"🌦️","night":"🌧️"},
    "81": {"day":"🌦️","night":"🌧️"},
    "82": {"day":"🌧️","night":"🌧️"},
    "95": {"day":"⛈️","night":"⛈️"}
  } as $g
  | .current as $c
  | ($g[$c.weather_code|tostring] // {day:"❓",night:"❓"}) as $e
  | "\(if $c.is_day == 1 then $e.day else $e.night end) \($c.temperature_2m)\(.current_units.temperature_2m)"')

sketchybar --set "$NAME" label="$weather"
