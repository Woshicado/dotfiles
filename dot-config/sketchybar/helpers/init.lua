-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

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
