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
	sbar.exec("memory_pressure | grep 'System-wide memory free percentage:' | awk '{print 100-$5}'", function(result)
		local used = tonumber(result) or 0
		local color = (used > 50 and 0xffff4444) or (used > 75 and 0xffffa500) or nil
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
  width = settings.group_paddings
})

memory_update()
