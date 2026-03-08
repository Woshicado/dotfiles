#!/bin/bash

CACHE_FILE="/tmp/mattermost_unread.json"
TTL=600 # seconds; I do not need real-time updates, so 10 minutes is fine

if [ -f "$CACHE_FILE" ]; then
  AGE=$(($(date +%s) - $(date -r "$CACHE_FILE" +%s)))
  if [ "$AGE" -lt "$TTL" ]; then
    cat "$CACHE_FILE"
    exit 0
  fi
fi

RESPONSE=$(
  sops exec-env ~/secrets.env 'curl -H "Authorization: Bearer ${MM_TOKEN}" ${MM_URL}/api/v4/users/${MM_USER_ID}/teams/${MM_TEAM_ID}/unread'
)

if [ "$RESPONSE" = "401" ]; then
  MM_TOKEN=$(curl -s -D - \
    -X POST ${MM_URL}/api/v4/users/login \
    -H "Content-Type: application/json" \
    -d '{"login_id":"${MM_USER_NAME}","password":"{MM_PASSWORD}"}' \
    -o /dev/null |
    grep -i "^token:" |
    awk '{print $2}' |
    tr -d '\r')

  if [ -z "$MM_TOKEN" ]; then
    echo "Failed to retrieve token" >&2
    exit 1
  fi

  sops decrypt secrets.env |
    sed "s/^MM_TOKEN=.*/MM_TOKEN=${MM_TOKEN}/" |
    sops encrypt --input-type dotenv --output-type dotenv /dev/stdin >secrets.env.tmp &&
    mv secrets.env.tmp ${HOME}/dotfiles/secrets.env

  RESPONSE=$(
    sops exec-env ~/secrets.env 'curl -H "Authorization: Bearer ${MM_TOKEN}" ${MM_URL}/api/v4/users/${MM_USER_ID}/teams/${MM_TEAM_ID}/unread'
  )
fi

if echo "$RESPONSE" | jq -e '.msg_count' >/dev/null 2>&1; then
  echo "$RESPONSE" >"$CACHE_FILE"
  echo "$RESPONSE"
else
  # Return stale cache rather than nothing if fetch failed
  cat "$CACHE_FILE" 2>/dev/null || echo '{"msg_count":0,"mention_count":0}'
fi
