#!/bin/bash
#
# Fetch current weather as JSON for the sketchybar weather item. Caches the last
# good response in /tmp and falls back to it when the API is slow or down, and
# caps the request time so a hung host can't stall the sketchybar exec callback.

CACHE_FILE="/tmp/weather_cache.json"
TTL=600 # seconds; the widget polls every 10 min, so serve cache within that window

if [ -f "$CACHE_FILE" ]; then
  AGE=$(($(date +%s) - $(date -r "$CACHE_FILE" +%s)))
  if [ "$AGE" -lt "$TTL" ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

RESPONSE=$(
  sops exec-env ~/secrets.env 'curl -sL --max-time 5 "https://api.openweathermap.org/data/2.5/weather?q=${POSH_OWM_LOCATION}&appid=${POSH_OWM_API_KEY}&units=metric"'
)

if echo "$RESPONSE" | jq -e '.main.temp' >/dev/null 2>&1; then
  echo "$RESPONSE" >"$CACHE_FILE"
  echo "$RESPONSE"
else
  # Fetch failed / errored; serve the last good response rather than nothing.
  cat "$CACHE_FILE" 2>/dev/null
fi
