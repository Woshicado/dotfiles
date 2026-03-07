#!/bin/bash
# Usage: toggle_app.sh "AppName"
# Example: toggle_app.sh "KeePassXC"

APP="$1"

if [ -z "$APP" ]; then
  echo "Usage: $0 \"AppName\""
  exit 1
fi

IS_FRONTMOST=$(/usr/bin/osascript -e "tell application \"System Events\" to return frontmost of process \"$APP\"" 2>/dev/null)

if [ "$IS_FRONTMOST" = "true" ]; then
  /usr/bin/osascript -e "tell application \"System Events\" to set visible of process \"$APP\" to false"
else
  open -a "$APP"
fi
