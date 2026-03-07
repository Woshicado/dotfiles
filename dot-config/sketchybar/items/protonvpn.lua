-- ==========================================================
-- PROTON VPN CONTROL
-- ==========================================================
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local icon_on = app_icons["ProtonVPN"] -- Shield with check (nerd font)
local icon_off = app_icons["ProtonVPN"] -- Same icon, different color
local active_color = colors.green

local protonvpn = sbar.add("item", "protonvpn", {
	position = "right",
	icon = {
		string = icon_off,
		font = "sketchybar-app-font:Regular:16.0",
		padding_left = 8,
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
				icon = { string = icon_on, color = active_color },
			})
		elseif status == "transitioning" then
			protonvpn:set({
				icon = { string = icon_off, color = colors.yellow },
			})
		else
			protonvpn:set({
				icon = { string = icon_off, color = colors.grey },
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

sbar.add("bracket", "items.protonvpn.bracket", { protonvpn.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "items.protonvpn.padding", {
	position = "right",
	width = settings.group_paddings,
})

update_protonvpn()
