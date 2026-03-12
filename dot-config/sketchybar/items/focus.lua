-- ==========================================================
-- FOCUS MODE CONTROL
-- ==========================================================
local colors = require("colors")
local settings = require("settings")

local icon_on = "􀆺 " -- Moon/focus icon
local icon_off = "􀆹 "
local active_color = colors.blue

local focus = sbar.add("item", "focus", {
	position = "right",
	icon = {
		string = icon_off,
		font = {
			family = "FiraCode Nerd Font",
			style = "Regular",
			size = 16.0,
		},
		padding_left = 8,
		y_offset = 1,
	},
	update_freq = 10,
})

local function update_focus()
	sbar.exec(
		[[osascript -e '
		tell application "System Events"
			tell application process "Control Center"
				return value of attribute "AXDescription" of first menu bar item of menu bar 1 whose description contains "Focus"
			end tell
		end tell'
	]],
		function(result)
			local status = result:gsub("\n", "")

			if status:find("On") or status:find("Active") then
				focus:set({ icon = { string = icon_on, color = active_color } })
			else
				focus:set({ icon = { string = icon_off, color = colors.grey } })
			end
		end
	)
end

local function get_focus_status(callback)
	sbar.exec(
		[[/bin/sh -c 'defaults read com.apple.controlcenter "NSStatusItem Visible FocusModes" 2>/dev/null; /usr/bin/shortcuts run "Get Current Focus" 2>/dev/null || echo "unknown"']],
		function(result)
			callback(result:gsub("\n", ""))
		end
	)
end

-- Use moonphase/do-not-disturb AppleScript API
local function update_focus()
	sbar.exec(
		"/bin/sh -c 'plutil -p ~/Library/DoNotDisturb/DB/Assertions.json 2>/dev/null | grep -c storeAssertionRecords'",
		function(result)
			local count = tonumber(result:match("%d+")) or 0
			if count > 0 then
				focus:set({ icon = { string = icon_on, color = active_color } })
			else
				focus:set({ icon = { string = icon_off, color = colors.grey } })
			end
		end
	)
end

focus:subscribe("mouse.clicked", function(env)
	sbar.exec(
		[[osascript -e '
		tell application "System Events"
			tell process "ControlCenter"
				click menu bar item 16 of menu bar 1
				delay 0.3
				click checkbox 1 of group 1 of window "Control Center"
        delay 0.1
        click menu bar item 16 of menu bar 1
			end tell
		end tell']],
		function()
			sbar.delay(0.3, update_focus)
		end
	)
end)

focus:subscribe("routine", update_focus)
focus:subscribe("forced", update_focus)

sbar.add("bracket", "items.focus.bracket", { focus.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "items.focus.padding", {
	position = "right",
	width = settings.group_paddings,
})

update_focus()
