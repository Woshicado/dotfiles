-- ==========================================================
-- BLUETOOTH INDICATOR
-- ==========================================================
local colors = require("colors")
local settings = require("settings")

local blueutil = "/opt/homebrew/bin/blueutil" -- adjust if needed

local icon_on = "󰂯" -- BT on  (nerd font)
local icon_off = "󰂲" -- BT off
local active_color = colors.blue
local idle_color = colors.white -- or colors.fg if you prefer

local bluetooth = sbar.add("item", "bluetooth", {
	position = "right",
	icon = {
		string = icon_off,
		font = {
			family = "FiraCode Nerd Font",
			style = "Regular",
			size = 16.0,
		},
		padding_left = 8,
	},
	label = {
		string = "",
		padding_right = 8,
	},
	update_freq = 5,
})

local function update_bluetooth()
	sbar.exec("blueutil --power", function(power_result)
		local power = tonumber(power_result:match("%d+")) or 0

		if power == 0 then
			bluetooth:set({ icon = { string = icon_off, color = colors.grey } })
			return
		end

		sbar.exec("blueutil --connected", function(conn_result)
			local count = 0
			for _ in conn_result:gmatch("\n") do
				count = count + 1
			end

			if count > 0 then
				bluetooth:set({ icon = { string = icon_on, color = active_color }, label = { string = count } })
			else
				bluetooth:set({ icon = { string = icon_on, color = idle_color }, label = { drawing = false } })
			end
		end)
	end)
end

bluetooth:subscribe("mouse.clicked", function(env)
	if env.BUTTON == "left" then -- dropdown
		sbar.exec([[osascript -e '
    tell application "System Events"
        tell process "ControlCenter"
            click menu bar item 3 of menu bar 1
        end tell
    end tell']])
	elseif env.BUTTON == "right" then -- System Settings
		sbar.exec("open 'x-apple.systempreferences:com.apple.BluetoothSettings'")
	end
end)

bluetooth:subscribe("routine", update_bluetooth)
bluetooth:subscribe("forced", update_bluetooth)

sbar.add("bracket", "items.bluetooth.bracket", { bluetooth.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "items.bluetooth.padding", {
	position = "right",
	width = settings.group_paddings,
})

update_bluetooth()
