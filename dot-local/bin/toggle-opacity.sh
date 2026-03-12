#!/usr/bin/env bash

OPACITY_LOW=0.85
OPACITY_HIGH=1.0

current=$(yabai -m query --windows --window | jq -r ".opacity >= $OPACITY_HIGH")

if $current; then
    yabai -m window --opacity $OPACITY_LOW
else
    yabai -m window --opacity 0.0 # $OPACITY_HIGH  # 0.0 == managed by yabai
fi
