-- ==========================================================
-- SPOTIFY INDICATOR (Inline)
-- ==========================================================
local colors = require("colors")
local icons = require("helpers.app_icons")
local settings = require("settings")

local position = "right"
local max_length = 28 -- Truncate text if longer than this; low because of notch
local logo_color = 0xff1db954

-- 1. Create the Main Item
local spotify_anchor = sbar.add("item", "spotify", {
	position = position,
	icon = {
		font = "sketchybar-app-font:Regular:16.0",
		string = icons["Spotify"], -- Spotify Logo
		color = logo_color, -- Spotify Green
		padding_left = 8,
	},
	label = {
		string = "Spotify",
		drawing = true,
		y_offset = 0,
		padding_right = 8,
	},
})

-- 2. Update Logic
local function update_spotify()
	---- ARTIST INFO
	-- set a to artist of current track
	-- return t & " - " & a

	sbar.exec(
		[[osascript -e '
        if application "Spotify" is running then
            tell application "Spotify"
                if player state is playing then
                    set t to name of current track
                    set a to artist of current track
                    return t & " - " & a
                else
                    return "paused"
                end
            end tell
        else
            return "stopped"
        end']],
		function(result)
			-- Clean up result (remove newlines)
			local status = result:gsub("\n", "")

			if status == "stopped" or status == "" then
				-- Hide entirely if Spotify isn't running
				spotify_anchor:set({ drawing = false })
			elseif status == "paused" then
				-- Paused State: Dimmed
				spotify_anchor:set({
					drawing = true,
					label = { string = "Paused", color = colors.grey },
					icon = { color = colors.grey },
				})
			else
				-- Playing State: Green
				if string.len(status) > max_length then
					status = string.sub(status, 1, max_length) .. "󰇘"
				end

				spotify_anchor:set({
					drawing = true,
					label = { string = status, color = logo_color },
					icon = { color = logo_color },
				})
			end
		end
	)
end

local function volume_scroll(env)
	local delta = env.INFO.delta
	if not (env.INFO.modifier == "ctrl") then
		delta = delta * 5.0
	end

	sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end
-- 3. Events
-- Update when Spotify sends a change event
sbar.add("event", "spotify_change", "com.spotify.client.PlaybackStateChanged")
spotify_anchor:subscribe("spotify_change", update_spotify)

-- Handle Mouse Clicks (Left = Play/Pause, Right = Next)
spotify_anchor:subscribe("mouse.clicked", function(env)
	local script = ""

	if env.BUTTON == "left" then
		script = 'tell application "Spotify" to playpause'
	elseif env.BUTTON == "right" then
		script = 'tell application "Spotify" to next track'
	end

	if script ~= "" then
		sbar.exec("osascript -e '" .. script .. "'")
	end
end)

spotify_anchor:subscribe("mouse.scrolled", volume_scroll)

sbar.add("bracket", "items.spotify.bracket", { spotify_anchor.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "items.spotify.padding", {
	position = position,
	width = settings.group_paddings,
})

-- Initial Load
update_spotify()
