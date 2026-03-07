#!/bin/bash
info=$(yabai -m query --spaces --display)
last=$(echo $info | jq '.[0]."has-focus"')

if [[ $last == "false" ]]; then
    yabai -m window --space prev --focus
    yabai -m space --focus prev
else
    space=$(echo $info | jq '.[-1].index')
    yabai -m window --space "$space" --focus
fi
