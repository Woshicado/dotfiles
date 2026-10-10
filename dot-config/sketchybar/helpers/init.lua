-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- A reload that lands while the previous config is still loading leaves that
-- config process running next to the new one, both adding and updating the same
-- items. Stop every other one; `$PPID` in the spawned shell is this process.
os.execute(
	"for p in $(pgrep -f '[l]ua .*sketchybar/sketchybarrc'); do "
		.. '[ "$p" != "$PPID" ] && kill "$p"; done >/dev/null 2>&1'
)

-- launchd appends everything sketchybar and its scripts print to these two files
-- and never trims them (they had reached 5.6 GB). Empty one once it passes 5 MB;
-- truncating is safe because launchd holds them open in append mode.
os.execute(
	"for f in /opt/homebrew/var/log/sketchybar/sketchybar.out.log /opt/homebrew/var/log/sketchybar/sketchybar.err.log; do "
		.. '[ "$(/usr/bin/stat -f%z "$f" 2>/dev/null || echo 0)" -gt 5000000 ] && : > "$f"; done 2>/dev/null'
)

-- Build the compiled helper binaries only when one is missing. Running
-- `make` unconditionally on every config load costs ~5 fork/execs, and — if a
-- `git pull` / re-stow bumps a `.c`/`.h` mtime — escalates to a synchronous
-- `clang -O3` + SkyLight/Carbon link that blocks the bar from drawing. This now
-- also runs on every display-guard restart, so gate it on binary existence to
-- keep the hot path free of it.
--
-- Edited a helper's C source? Rebuild manually: `make -C ~/.config/sketchybar/helpers`.
local helpers_dir = os.getenv("HOME") .. "/.config/sketchybar/helpers"
local binaries = {
	helpers_dir .. "/event_providers/cpu_load/bin/cpu_load",
	helpers_dir .. "/event_providers/network_load/bin/network_load",
	helpers_dir .. "/menus/bin/menus",
	helpers_dir .. "/display_watch/bin/display_watch",
}

local function exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

for _, bin in ipairs(binaries) do
	if not exists(bin) then
		os.execute("(cd " .. helpers_dir .. " && make)")
		break
	end
end

-- Watch for display topology changes and hand them to display_guard.sh, which
-- freezes sketchybar for the burst and then restarts it once. Started here (not
-- via sbar.exec) so it is up before any item exists; it detaches itself, so the
-- guard's restart of sketchybar does not take it down mid-debounce.
os.execute(
	"killall display_watch >/dev/null 2>&1; "
		.. helpers_dir
		.. "/display_watch/bin/display_watch "
		.. helpers_dir
		.. "/display_guard.sh >/dev/null 2>&1 &"
)
