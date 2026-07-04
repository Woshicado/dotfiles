#!/usr/bin/env bash
#
# claude_status.sh — bridge between Claude Code hooks and the sketchybar badge.
#
# Usage (from a Claude Code hook):
#   claude_status.sh <status>
# where <status> is one of: working | done | waiting | clear | notify
#
# "notify" is for the Notification hook, which fires both for real permission/
# confirmation prompts (-> red) and for purely informational notifications such
# as idle reminders or end-of-turn recaps (-> green, not blocking). We inspect
# the notification `message` to tell them apart.
#
# Claude Code passes the hook payload as JSON on stdin; we read `session_id`
# from it so that multiple concurrent Claude instances are tracked separately.
# Each session keeps one tiny state file in $STATE_DIR; the sketchybar item
# aggregates all of them. After updating state we poke sketchybar so the badge
# refreshes immediately.

set -euo pipefail

STATUS="${1:-working}"
STATE_DIR="${HOME}/.local/state/sketchybar-claude"
mkdir -p "$STATE_DIR"

# Read the JSON payload from stdin (if any) and pull out the session id.
payload="$(cat 2>/dev/null || true)"
session_id=""
if [ -n "$payload" ] && command -v jq >/dev/null 2>&1; then
  session_id="$(printf '%s' "$payload" | jq -r '.session_id // empty' 2>/dev/null || true)"
fi
[ -z "$session_id" ] && session_id="default"

# Sanitise so it is always a safe single filename.
session_id="${session_id//\//_}"

case "$STATUS" in
  clear)
    rm -f "$STATE_DIR/$session_id"
    ;;
  notify)
    # Only a permission/approval/confirmation request is genuinely blocking
    # (red). Everything else the Notification hook reports (idle reminders,
    # informational recaps) means "your turn" at most -> treat as done (green).
    message=""
    if [ -n "$payload" ] && command -v jq >/dev/null 2>&1; then
      message="$(printf '%s' "$payload" | jq -r '.message // empty' 2>/dev/null || true)"
    fi
    message_lc="$(printf '%s' "$message" | tr '[:upper:]' '[:lower:]')"
    # Claude Code's permission prompt message is "Claude needs your permission
    # to use <tool>". Match only that so informational notifications (recaps,
    # idle reminders) never turn the badge red. Red is cleared again by the
    # PostToolUse -> working hook once the approved tool actually runs.
    case "$message_lc" in
      *permission*)
        printf '%s\n' "waiting" > "$STATE_DIR/$session_id"
        ;;
      *)
        printf '%s\n' "done" > "$STATE_DIR/$session_id"
        ;;
    esac
    ;;
  working|done|waiting)
    printf '%s\n' "$STATUS" > "$STATE_DIR/$session_id"
    ;;
  *)
    printf '%s\n' "working" > "$STATE_DIR/$session_id"
    ;;
esac

# Garbage-collect state files from sessions that died without a SessionEnd
# (e.g. a crash or kill -9). Anything untouched for a day is stale. This hook can
# fire many times per second during active tool use, so sweep at most once an
# hour instead of scanning the directory on every invocation.
GC_STAMP="$STATE_DIR/.last_gc"
if [ ! -f "$GC_STAMP" ] || [ "$(( $(date +%s) - $(date -r "$GC_STAMP" +%s) ))" -ge 3600 ]; then
  find "$STATE_DIR" -type f -mtime +1 -delete 2>/dev/null || true
  touch "$GC_STAMP" 2>/dev/null || true
fi

# Tell the badge to re-read state. Non-fatal if the bar is not running.
if command -v sketchybar >/dev/null 2>&1; then
  sketchybar --trigger claude_status >/dev/null 2>&1 || true
fi

exit 0
