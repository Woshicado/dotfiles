#!/bin/sh
#
# display_guard.sh — stop sketchybar from thrashing on display changes.
#
# On a display topology change (monitor connect/disconnect, rearrange, or
# resolution change) macOS delivers a *burst* of CGDisplay reconfiguration
# callbacks — one per affected display, per change type, often re-fired as the
# transition settles. sketchybar reacts to EACH callback with a full
#   freeze -> reset (destroy every bar, drop every item window)
#          -> refresh(forced) (recreate + relayout + redraw every item)
# so a single physical change triggers a dozen full teardown/rebuild cycles,
# each a few hundred synchronous WindowServer ops — while WindowServer is already
# busy recompositing the change. That contention is what hangs the whole UI.
#
# A clean restart does that rebuild exactly once, which is why `killall
# sketchybar` (relaunched by the LaunchAgent's KeepAlive) is faster than letting
# it churn. This guard automates and improves on that: it freezes sketchybar for
# the duration of the burst so it never thrashes, then does one clean restart
# once the layout has settled.
#
# Invoked from yabai display_* signals (see ~/.config/yabai/yabairc).
#
# Flow, per signal:
#   1. SIGSTOP sketchybar — halts the rebuild loop. A stopped process has not
#      exited, so launchd KeepAlive leaves it alone (no premature restart).
#   2. Stamp a unique token, then spawn a detached debouncer. After QUIET
#      seconds of no further signals, only the most recent invocation SIGKILLs
#      the daemon; KeepAlive then relaunches it once, reading the settled
#      display layout => a single clean rebuild.
#
# Failure mode is benign: if the debouncer never runs, sketchybar stays frozen
# until the next display event (which re-arms it) or a manual `killall
# sketchybar` — i.e. no worse than the pre-existing manual workaround.

# Seconds of quiet (no further display signals) before we consider the layout
# settled and do the clean restart. Bump this if fast transitions still catch a
# straggler reconfiguration; lower it to shorten the bar's absence.
QUIET=1.5

STAMP="${TMPDIR:-/tmp}/sketchybar-display-guard.stamp"

# Detached debouncer branch (re-exec of this script via nohup, see below).
if [ "$1" = "--wait" ]; then
	sleep "$QUIET"
	# Only the most recent invocation (its token still in the stamp) restarts.
	if [ "$(cat "$STAMP" 2>/dev/null)" = "$2" ]; then
		/usr/bin/killall -KILL sketchybar 2>/dev/null
	fi
	exit 0
fi

# Main branch: freeze immediately, then arm the debouncer.
/usr/bin/killall -STOP sketchybar 2>/dev/null

mine="$$"
echo "$mine" > "$STAMP"

# Launch the debouncer fully detached (nohup + background) so it survives yabai
# reaping this action process.
nohup "$0" --wait "$mine" >/dev/null 2>&1 &
