local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local display = require("helpers.display")

local function setup_for_display(display_index)
	local position = display.is_builtin(display_index) and "q" or "center"
	local suffix = tostring(display_index)

	sbar.add("item", "widgets.notifications" .. suffix, {
		display = display_index,
		position = position,
	})

	-- CONFIG: Match these to your Dock names
	local apps_to_track = {
		"Microsoft Teams",
		"Thunderbird",
		"Mattermost",
		"Signal",
		"WhatsApp",
		"Discord",
	}

	-- Table to hold dynamically created per-app items
	local app_items = {}

	-- The summary badge (total count) shown on the right
	local notifications = sbar.add("item", "widgets.notifications" .. suffix, {
		display = display_index,
		position = position,
		icon = {
			string = "| ",
			font = "FiraCode Nerd Font:Bold:14.0",
			color = colors.grey,
			padding_left = -2,
		},
		label = {
			string = "0",
			font = "FiraCode Nerd Font:Bold:12.0",
			color = colors.grey,
		},
		padding_right = 10,
		update_freq = 5,
		drawing = false,
	})

	-- Parse "AppName:count\n..." into a table { AppName = count, ... }
	local function parse_app_counts(raw)
		local result = {}
		for line in raw:gmatch("[^\n]+") do
			local app, count = line:match("^(.+):(%d+)$")
			if app and count then
				result[app] = tonumber(count)
			end
		end
		return result
	end

	-- Return (or lazily create) a sketchybar item for a given app
	local function get_or_create_item(app_name)
		if app_items[app_name] then
			return app_items[app_name]
		end

		local safe_name = app_name:gsub("%s+", "_"):lower()
		local item_name = "widgets.notifications." .. safe_name

		local item = sbar.add("item", item_name .. suffix, {
			display = display_index,
			position = position,
			drawing = true,
			icon = {
				string = app_icons[app_name] or "?",
				font = "sketchybar-app-font:Regular:16.0",
				color = colors.white,
				padding_left = 4,
			},
			label = {
				string = "",
				font = "FiraCode Nerd Font:Bold:10.0",
				color = colors.red,
				y_offset = 6,
				padding_left = 0,
				padding_right = 0,
			},
			click_script = 'open -a "' .. app_name .. '"',
		})

		app_items[app_name] = item
		return item
	end

	-- Built once at load time, reused on every update tick
	local function build_osascript_cmd(app_list)
		local quoted = {}
		for _, app in ipairs(app_list) do
			table.insert(quoted, '"' .. app .. '"')
		end

		local lines = {
			"set appList to {" .. table.concat(quoted, ", ") .. "}",
			'set output to ""',
			'tell application "System Events"',
			'tell process "Dock"',
			"repeat with appName in appList",
			"try",
			'set unreadLabel to value of attribute "AXStatusLabel" of UI element appName of list 1',
			"if unreadLabel is not missing value then",
			'if unreadLabel is not "" then',
			"try",
			"set countVal to unreadLabel as integer",
			"on error",
			"set countVal to 1",
			"end try",
			'set output to output & appName & ":" & countVal & linefeed',
			"end if",
			"end if",
			"on error",
			"end try",
			"end repeat",
			"end tell",
			"end tell",
			"return output",
		}

		local cmd = "osascript"
		for _, line in ipairs(lines) do
			cmd = cmd .. " -e '" .. line .. "'"
		end
		return cmd
	end

	local OSASCRIPT_CMD = build_osascript_cmd(apps_to_track)

	-- Pre-create all items so the bracket can include them from the start.
	for _, app_name in ipairs(apps_to_track) do
		get_or_create_item(app_name)
	end

	-- Bracket wraps all items into one visual pill.
	local bracket_members = { notifications.name }
	for _, app_name in ipairs(apps_to_track) do
		local safe_name = app_name:gsub("%s+", "_"):lower()
		table.insert(bracket_members, "widgets.notifications." .. safe_name .. suffix)
	end

	sbar.add("bracket", "widgets.notifications" .. suffix .. ".bracket", bracket_members, {
		display = display_index,
		background = { color = colors.bg1 },
	})

	sbar.add("item", "widgets.notifications" .. suffix .. ".padding", {
		display = display_index,
		position = position,
		width = settings.group_paddings,
	})

	-- ── Expand / collapse animation ──────────────────────────────────────────
	local expanded = true
	-- last_counts holds the most recent notification state so we can
	-- correctly show/hide items when collapsing and re-expanding
	local last_counts = {}

	local function set_app_items_visible(visible)
    -- I could animate this but it seems laggy and I'd rather have it snappy instead
		for _, app_name in ipairs(apps_to_track) do
			local item = get_or_create_item(app_name)
			local count = last_counts[app_name]
			-- Only show items that actually have notifications when expanding
			item:set({ drawing = visible })
		end
	end

	notifications:subscribe("mouse.clicked", function()
		expanded = not expanded
		set_app_items_visible(expanded)
	end)
	-- ─────────────────────────────────────────────────────────────────────────

	-- Main update function
	local function update_notifications()
		sbar.exec(OSASCRIPT_CMD, function(result)
			local app_counts = parse_app_counts(result or "")
			last_counts = app_counts -- keep a copy for expand/collapse

			local total = 0
			for _, count in pairs(app_counts) do
				total = total + count
			end

			for _, app_name in ipairs(apps_to_track) do
				local item = get_or_create_item(app_name)
				local count = app_counts[app_name]

				if count and count > 0 then
					item:set({
						-- Only draw if currently expanded
						drawing = expanded,
						icon = { color = colors.white },
						label = { string = tostring(count) },
					})
				else
					item:set({
						icon = { color = colors.grey },
						label = { string = "", color = colors.grey },
					})
				end
			end

			if total > 0 then
				notifications:set({
					drawing = true,
					icon = { string = "|  ", color = colors.blue },
					label = { string = tostring(total), color = colors.blue },
				})
			else
				notifications:set({
					icon = { string = "|  ", color = colors.grey },
					label = { string = "0", color = colors.grey },
				})
			end
		end)
	end

	-- Subscribe to periodic and forced updates
	notifications:subscribe("routine", update_notifications)
	notifications:subscribe("forced", update_notifications)

	if position == "center" then
		for _, app_name in ipairs(apps_to_track) do
			local safe_name = app_name:gsub("%s+", "_"):lower()
			sbar.exec(
				"sketchybar --reorder widgets.notifications."
					.. safe_name
					.. suffix
					.. " widgets.notifications"
					.. suffix
			)
		end
	end

	update_notifications()
end

for i = 1, display.count do
	if not display.is_narrow(i, 1800) then
		setup_for_display(i)
	end
end
