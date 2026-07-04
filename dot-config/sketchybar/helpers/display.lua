local display = {}

-- Query the displays once and parse in Lua (no python interpreter spawn on the
-- critical load path). `sketchybar --query displays` returns a JSON array whose
-- order is the display arrangement order; each entry has a DirectDisplayID and a
-- frame with w/h. Fields appear in the order DirectDisplayID -> ... -> w -> h,
-- so a single non-greedy capture pulls all three per display.
local handle = io.popen("sketchybar --query displays")
local raw = handle:read("*a")
handle:close()

display.count = 0
display.widths = {}
display.heights = {}
display.direct_ids = {}

for did, w, h in raw:gmatch('"DirectDisplayID"%s*:%s*(%d+).-"w"%s*:%s*([%d%.]+).-"h"%s*:%s*([%d%.]+)') do
	display.count = display.count + 1
	display.widths[display.count] = tonumber(w)
	display.heights[display.count] = tonumber(h)
	display.direct_ids[display.count] = tonumber(did)
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
