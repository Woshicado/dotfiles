-- ==========================================================
-- ACTION ITEMS
-- (Amphetamine, Focus Mode, ProtonVPN)
-- ==========================================================
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- ==========================================================
-- AMPHETAMINE CONTROL
-- ==========================================================
local icon_amphetamine_on = "" -- Filled pill
local icon_amphetamine_off = "" -- Empty pill
local active_color_amphetamine = colors.green

local amphetamine = sbar.add("item", "amphetamine", {
	position = "right",
	icon = {
		string = icon_amphetamine_off,
		font = {
			family = "FiraCode Nerd Font",
			style = "Regular",
			size = 16.0,
		},
    padding_left = 0,
    padding_right = 0,
	},
	update_freq = 10, -- Poll every 10s as a fallback
})

local function update_amphetamine()
	sbar.exec(
		[[osascript -e '
        if application "Amphetamine" is running then
            tell application "Amphetamine"
                if session is active then
                    return "on"
                else
                    return "off"
                end if
            end tell
        else
            return "closed"
        end if']],
		function(result)
			local status = result:gsub("\n", "")

			if status == "on" then
				amphetamine:set({
					icon = { string = icon_amphetamine_on, color = active_color_amphetamine },
				})
			elseif status == "off" then
				amphetamine:set({
					icon = { string = icon_amphetamine_off, color = colors.grey },
				})
			else
				-- Hide if app isn't even open
				amphetamine:set({ drawing = false })
			end
		end
	)
end

amphetamine:subscribe("mouse.clicked", function(env)
	sbar.exec(
		[[osascript -e '
        if application "Amphetamine" is running then
            tell application "Amphetamine"
                if session is active then
                    return "on"
                else
                    return "off"
                end if
            end tell
        else
            return "closed"
        end if']],
		function(result)
			local status = result:gsub("\n", "")

			local command
			if status == "on" then
				command = [[tell application "Amphetamine" to end session]]
			elseif status == "off" then
				command = [[tell application "Amphetamine" to start new session]]
			else
				-- Hide if app isn't even open
				amphetamine:set({ drawing = false })
				return
			end

			-- Execute the chosen command
			sbar.exec("osascript -e '" .. command .. "'", function()
				-- Slight delay to let the app state change before updating the bar
				sbar.delay(0.1, update_amphetamine)
			end)
		end
	)
end)

amphetamine:subscribe("routine", update_amphetamine)
amphetamine:subscribe("forced", update_amphetamine)

-- ==========================================================
-- FOCUS MODE CONTROL
-- ==========================================================
local icon_focus_on = "􀆺 " -- Moon/focus icon
local icon_focus_off = "􀆹 "
local active_color_focus = colors.blue

local focus = sbar.add("item", "focus", {
	position = "right",
	icon = {
		string = icon_focus_off,
		font = {
			family = "FiraCode Nerd Font",
			style = "Regular",
			size = 16.0,
		},
    padding_left = 0,
    padding_right = 0,
		y_offset = 1,
	},
	update_freq = 10,
})

-- Use moonphase/do-not-disturb AppleScript API
local function update_focus()
	sbar.exec(
		"/bin/sh -c 'plutil -p ~/Library/DoNotDisturb/DB/Assertions.json 2>/dev/null | grep -c storeAssertionRecords'",
		function(result)
			local count = tonumber(result:match("%d+")) or 0
			if count > 0 then
				focus:set({ icon = { string = icon_focus_on, color = active_color_focus } })
			else
				focus:set({ icon = { string = icon_focus_off, color = colors.grey } })
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

-- ==========================================================
-- PROTON VPN CONTROL
-- ==========================================================
local icon_protonvpn = app_icons["ProtonVPN"]
local active_color_protonvpn = colors.green

local protonvpn = sbar.add("item", "protonvpn", {
	position = "right",
	icon = {
		string = icon_protonvpn,
		font = "sketchybar-app-font:Regular:17.0",
    padding_left = 6,
    padding_right = 0,
		y_offset = 1,
	},
	update_freq = 10,
})

local function get_vpn_status(callback)
	sbar.exec("scutil --nc status ProtonVPN 2>/dev/null | head -1", function(result)
		local status = result:gsub("\n", ""):gsub("%s+", "")
		-- scutil returns "Connected", "Disconnected", "Connecting", etc.
		if status == "Connected" then
			callback("on")
		elseif status == "Disconnected" or status == "" then
			callback("off")
		else
			-- Connecting / Disconnecting — treat as transitioning
			callback("transitioning")
		end
	end)
end

local function update_protonvpn()
	get_vpn_status(function(status)
		if status == "on" then
			protonvpn:set({
				icon = { color = active_color_protonvpn },
			})
		elseif status == "transitioning" then
			protonvpn:set({
				icon = { color = colors.yellow },
			})
		else
			protonvpn:set({
				icon = { color = colors.grey },
			})
		end
	end)
end

protonvpn:subscribe("mouse.clicked", function(env)
	get_vpn_status(function(status)
		if status == "on" then
			sbar.exec("scutil --nc stop ProtonVPN", function()
				sbar.delay(0.5, update_protonvpn)
			end)
		elseif status == "off" then
			sbar.exec("scutil --nc start ProtonVPN", function()
				sbar.delay(0.5, update_protonvpn)
			end)
		end
		-- Do nothing while transitioning to avoid conflicting commands
	end)
end)

protonvpn:subscribe("routine", update_protonvpn)
protonvpn:subscribe("forced", update_protonvpn)

-- ==========================================================
-- BRACKET AND PADDING
-- ==========================================================
sbar.add("bracket", "action_items_bracket", { amphetamine.name, focus.name, protonvpn.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "action_items_padding", {
	position = "right",
	width = settings.group_paddings,
})

-- Initial Load
update_amphetamine()
update_focus()
update_protonvpn()
