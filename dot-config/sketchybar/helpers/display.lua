local display = {}

-- Query once, parse everything
local handle = io.popen(
	'sketchybar --query displays | python3 -c "'
		.. "import json,sys; d=json.load(sys.stdin); "
		.. "[print(x['frame']['w'], x['frame']['h'], x['DirectDisplayID']) for x in d]\""
)

display.count = 0
display.widths = {}
display.heights = {}
display.direct_ids = {}

for w, h, did in handle:read("*a"):gmatch("(%S+) (%S+) (%S+)") do
	display.count = display.count + 1
	display.widths[display.count] = tonumber(w)
	display.heights[display.count] = tonumber(h)
	display.direct_ids[display.count] = tonumber(did)
end
handle:close()

-- Built-in display always has DirectDisplayID == 1
display.is_builtin = function(index)
	return display.direct_ids[index] == 1
end

-- Portrait orientation
display.is_portrait = function(index)
	return display.heights[index] > display.widths[index]
end

-- Should this display show compact/minimal widgets?
display.is_narrow = function(index, threshold)
	threshold = threshold or 1200
	return display.widths[index] < threshold
end

return display
