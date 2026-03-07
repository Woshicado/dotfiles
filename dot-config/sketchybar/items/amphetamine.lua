-- ==========================================================
-- AMPHETAMINE CONTROL
-- ==========================================================
local colors = require("colors")
local settings = require("settings")

-- Icons: You can use an icon from your icons.lua or a raw SF Symbol
local icon_on = "" -- Filled pill
local icon_off = "" -- Empty pill
local active_color = colors.yellow -- Yellow/Gold

local amphetamine = sbar.add("item", "amphetamine", {
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
					icon = { string = icon_on, color = active_color },
					-- label = { string = "Active", color = active_color },
				})
			elseif status == "off" then
				amphetamine:set({
					icon = { string = icon_off, color = colors.grey },
					-- label = { string = "Off", color = colors.grey },
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
			end

			-- 3. Execute the chosen command
			sbar.exec("osascript -e '" .. command .. "'", function()
				-- Slight delay to let the app state change before updating the bar
				sbar.delay(0.1, update_amphetamine)
			end)
		end
	)
end)

-- Update on periodic routine or manual refresh
amphetamine:subscribe("routine", update_amphetamine)
amphetamine:subscribe("forced", update_amphetamine)

-- Optional: Bracket for styling
sbar.add("bracket", "widgets.amphetamine.bracket", { amphetamine.name }, {
	background = { color = colors.bg1 },
})

-- Padding
sbar.add("item", "widgets.amphetamine.padding", {
	position = "right",
	width = settings.group_paddings,
})

-- Initial Load
update_amphetamine()
