local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "items.battery", {
	position = "right",
	-- Spacing within the shared power pill: about 12 pt to the volume icon. The
	-- label is never used, and its default paddings would widen the gap.
	padding_right = 3,
	label = { drawing = false },
	icon = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 19.0,
		},
    padding_right = -1,
	},
  -- label = { font = { family = settings.font.numbers } },
	update_freq = 180,
	popup = { align = "center" },
})

local battery_percent = sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		string = "Battery Percent:",
		width = 100,
		align = "left",
	},
	label = {
		string = "???%",
		width = 100,
		align = "right",
	},
})

local remaining_time = sbar.add("item", {
	position = "popup." .. battery.name,
	icon = {
		string = "Time Remaining:",
		width = 100,
		align = "left",
	},
	label = {
		string = "??:??h",
		width = 100,
		align = "right",
	},
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
	sbar.exec("pmset -g batt", function(batt_info)
		local icon = "!"
		local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
    end

		local color = colors.green
		local charging, _, _ = batt_info:find("AC Power")

		if charging then
			icon = icons.battery.charging
		else
			if found and charge > 80 then
				icon = icons.battery._100
			elseif found and charge > 60 then
				icon = icons.battery._75
			elseif found and charge > 40 then
				icon = icons.battery._50
			elseif found and charge > 20 then
				icon = icons.battery._25
				color = colors.orange
			else
				icon = icons.battery._0
				color = colors.red
			end
		end

		local lead = ""
		if found and charge < 10 then
			lead = "0"
		end

		battery:set({
			icon = {
				string = icon,
				color = color,
			},
		})
	end)
end)

battery:subscribe("mouse.clicked", function(env)
	local drawing = battery:query().popup.drawing
	battery:set({ popup = { drawing = "toggle" } })

	if drawing == "off" then
		sbar.exec("pmset -g batt", function(batt_info)
			local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
			local label = found and remaining .. "h" or "No estimate"
			remaining_time:set({ label = label })

			local found, _, charge = batt_info:find("(%d+)%%")
			if found then
				charge = tonumber(charge)
				label = found and charge .. "%" or "??%"
			end
			battery_percent:set({ label = label })
		end)
	end
end)

-- One pill for the power and sound group: volume (items/volume.lua, loaded
-- before this) and battery.
sbar.add("bracket", "items.power.bracket", { "items.volume", battery.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "items.battery.padding", {
	position = "right",
	width = settings.group_paddings,
})
