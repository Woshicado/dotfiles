local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local memory = sbar.add("graph", "memory", 42, {
	position = "right",
	update_freq = 5,
	graph = { color = colors.blue },
	background = {
		height = 22,
		color = { alpha = 0 },
		border_color = { alpha = 0 },
		drawing = true,
	},
	icon = {
		string = "􀫦",
	},
	label = {
		string = "ram ??%",
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		align = "right",
		padding_right = 0,
		width = 0,
		y_offset = 4,
	},
	padding_right = settings.paddings + 6,
})

local function memory_update()
	sbar.exec("memory_pressure", function(result)
		result = result or ""
		local total = tonumber(result:match("%((%d+) pages"))
		local active = tonumber(result:match("Pages active:%s*(%d+)"))
		local wired = tonumber(result:match("Pages wired down:%s*(%d+)"))
		local compressor = tonumber(result:match("Pages used by compressor:%s*(%d+)"))
		local used = 0
		if total and total > 0 and active and wired and compressor then
			used = (active + wired + compressor) / total * 100
		end
		-- Higher usage is more alarming: red past 75%, orange past 50%.
		local color = (used > 75 and 0xffff4444) or (used > 50 and 0xffffa500) or nil
		memory:push({ used / 100. })
		memory:set({
			icon = { color = color or colors.white },
			graph = { color = color },
			label = { string = "ram " .. math.floor(used) .. "%", color = color or colors.white },
		})
	end)
end

memory:subscribe("routine", memory_update)

sbar.add("bracket", "items.ram.bracket", { memory.name }, {
	background = { color = colors.bg1, drawing = true },
})

sbar.add("item", "items.ram.padding", {
	position = "right",
	width = settings.group_paddings,
})

memory_update()
