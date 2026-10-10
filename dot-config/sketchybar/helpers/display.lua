local display = {}

-- Query the displays once, through the Lua module rather than the `sketchybar`
-- CLI: while sketchybar is busy (re)loading, the CLI regularly gives up waiting
-- and prints nothing, which used to look like "no displays". The result is an
-- array in display arrangement order; each entry has a DirectDisplayID and a
-- frame with x/y/w/h.
local displays
for _ = 1, 10 do
	local ok, result = pcall(sbar.query, "displays")
	if ok and type(result) == "table" and #result > 0 then
		displays = result
		break
	end
	os.execute("sleep 0.1")
end

display.count = 0
display.widths = {}
display.heights = {}
display.direct_ids = {}
display.xs = {}
-- display index -> name of the notification pill's bracket on that display, filled
-- in by items/notifications.lua for the displays that get one.
display.notifications = {}

for index, entry in ipairs(displays or {}) do
	display.count = index
	display.xs[index] = tonumber(entry.frame.x)
	display.widths[index] = tonumber(entry.frame.w)
	display.heights[index] = tonumber(entry.frame.h)
	display.direct_ids[index] = tonumber(entry.DirectDisplayID)
end

display.is_builtin = function(index)
	return display.direct_ids[index] == 1
end

display.is_portrait = function(index)
	return display.heights[index] > display.widths[index]
end

display.is_narrow = function(index, threshold)
	threshold = threshold or 1200
	return display.widths[index] < threshold
end

return display
