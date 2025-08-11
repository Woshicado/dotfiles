#!/bin/bash
info=$(yabai -m query --spaces --display)
last=$(echo $info | jq '.[-1]."has-focus"')

if [[ $last == "false" ]]; then
    yabai -m window --space next --focus
else
    space=$(echo $info | jq '.[0].index')
    yabai -m window --space "$space" --focus
fi
