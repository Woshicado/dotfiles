local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local display = require("helpers.display")

local function setup_for_display(display_index)
	local position = display.is_builtin(display_index) and "q" or "center"
	local suffix = tostring(display_index)

	sbar.add("item", "items.notifications" .. suffix, {
		display = display_index,
		position = position,
	})

	-- CONFIG: Match these to your Dock names.
	-- Each entry can be either a plain string (app name) or a table with:
	--   name    = "App Name"          (required)
	--   command = "shell command"     (optional, overrides default `open -a "App"`)
	local apps_to_track = {
		{
			name = "Microsoft Teams",
			command = "open 'msteams://chats'",
		},
		"Thunderbird",
		"Mattermost",
		"Signal",
		"WhatsApp",
		"Discord",
	}

	-- Normalize apps_to_track so every entry is a table { name, command }
	local function normalize(entry)
		if type(entry) == "string" then
			return { name = entry, command = nil }
		end
		return entry
	end

	-- Table to hold dynamically created per-app items
	local app_items = {}

	-- The summary badge (total count) shown on the right
	local notifications = sbar.add("item", "items.notifications" .. suffix, {
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
		drawing = true,
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

	-- Return (or lazily create) a sketchybar item for a given app entry
	local function get_or_create_item(entry)
		entry = normalize(entry)
		local app_name = entry.name

		if app_items[app_name] then
			return app_items[app_name]
		end

		local safe_name = app_name:gsub("%s+", "_"):lower()
		local item_name = "items.notifications." .. safe_name

		-- Use a custom command if provided, otherwise fall back to plain `open -a`
		local click_cmd = entry.command or ('open -a "' .. app_name .. '"')

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
			click_script = click_cmd,
		})

		app_items[app_name] = item
		return item
	end

	-- Built once at load time, reused on every update tick
	local function build_osascript_cmd(app_list)
		local quoted = {}
		for _, entry in ipairs(app_list) do
			local name = normalize(entry).name
			table.insert(quoted, '"' .. name .. '"')
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
	for _, entry in ipairs(apps_to_track) do
		get_or_create_item(entry)
	end

	sbar.delay(1, function()
		local order_cmd = "sketchybar --reorder"

		if position == "center" then
			-- Reverse order for center position since sketchybar mirrors it
			for i = #apps_to_track, 1, -1 do
				local name = normalize(apps_to_track[i]).name
				local safe_name = name:gsub("%s+", "_"):lower()
				order_cmd = order_cmd .. " items.notifications." .. safe_name .. suffix
			end
			order_cmd = order_cmd .. " " .. notifications.name
		else
			order_cmd = order_cmd .. " " .. notifications.name
			for _, entry in ipairs(apps_to_track) do
				local name = normalize(entry).name
				local safe_name = name:gsub("%s+", "_"):lower()
				order_cmd = order_cmd .. " items.notifications." .. safe_name .. suffix
			end
		end

		sbar.exec(order_cmd)
	end)

	-- Bracket wraps all items into one visual pill.
	local bracket_members = { notifications.name }
	for _, entry in ipairs(apps_to_track) do
		local name = normalize(entry).name
		local safe_name = name:gsub("%s+", "_"):lower()
		table.insert(bracket_members, "items.notifications." .. safe_name .. suffix)
	end

	sbar.add("bracket", "items.notifications" .. suffix .. ".bracket", bracket_members, {
		display = display_index,
		background = { color = colors.bg1 },
	})

	sbar.add("item", "items.notifications" .. suffix .. ".padding", {
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
		for _, entry in ipairs(apps_to_track) do
			local item = get_or_create_item(entry)
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

			for _, entry in ipairs(apps_to_track) do
				local app_name = normalize(entry).name
				local item = get_or_create_item(entry)
				local count = app_counts[app_name]

				if count and count > 0 then
					item:set({
						-- Only draw if currently expanded
						drawing = expanded,
						icon = { color = colors.white },
						label = { string = tostring(count), color = colors.red },
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
					drawing = true,
					icon = { string = "|  ", color = colors.grey },
					label = { string = "0", color = colors.grey },
				})
			end
		end)
	end

	-- Subscribe to periodic and forced updates
	notifications:subscribe("routine", update_notifications)
	notifications:subscribe("forced", update_notifications)

	-- if position == "center" then
	-- 	for _, entry in ipairs(apps_to_track) do
	-- 		local name = normalize(entry).name
	-- 		local safe_name = name:gsub("%s+", "_"):lower()
	-- 		sbar.exec(
	-- 			"sketchybar --reorder items.notifications." .. safe_name .. suffix .. " items.notifications" .. suffix
	-- 		)
	-- 	end
	-- end

	update_notifications()
end

for i = 1, display.count do
	if not display.is_narrow(i, 1800) then
		setup_for_display(i)
	end
end
