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

	local apps_to_track = {
		{
			name = "Microsoft Teams",
			command = "open 'msteams://chats'",
		},
		{
			name = "Thunderbird",
			count_command = "notmuch count tag:unread",
			count_command2 = "notmuch count --output=threads tag:important OR tag:todo",
		},
		"Mattermost",
		"Signal",
		"WhatsApp",
		"Discord",
	}

	-- Normalize apps_to_track so every entry is a table { name, command, count_command, count_command2 }
	local function normalize(entry)
		if type(entry) == "string" then
			return { name = entry, command = nil, count_command = nil, count_command2 = nil }
		end
		return entry
	end

	-- Table to hold dynamically created per-app items
	-- Each entry: { icon = <item>, primary = <item>, secondary = <item>|nil }
	-- For apps without count_command2, icon and primary are merged into one item
	-- and secondary is nil.
	local app_items = {}

	-- The summary badge (total count) shown on the right
	local notifications = sbar.add("item", "items.notifications" .. suffix, {
		display = display_index,
		position = position,
		icon = {
			string = "|  ",
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

	-- Return (or lazily create) item handles for a given app entry.
	--
	-- For apps WITHOUT count_command2:
	--   A single item holds both the icon and the primary count label.
	--   { icon = item, primary = item, secondary = nil }
	--
	-- For apps WITH count_command2 we mirror the wifi_up/wifi_down pattern exactly:
	--   1. icon-only item         — the app glyph, no label
	--   2. primary label item     — width=0, y_offset=4  (red, top)
	--   3. secondary label item   — normal width, y_offset=-4 (yellow, bottom)
	--   Items 2 and 3 overlap item 1 horizontally because item 2 has width=0.
	--   { icon = item1, primary = item2, secondary = item3 }
	local function get_or_create_item(entry)
		entry = normalize(entry)
		local app_name = entry.name

		if app_items[app_name] then
			return app_items[app_name]
		end

		local safe_name = app_name:gsub("%s+", "_"):lower()
		local base = "items.notifications." .. safe_name
		local click_cmd = entry.command or ('open -a "' .. app_name .. '"')
		local has_secondary = entry.count_command2 ~= nil

		local icon_item, primary, secondary

		if not has_secondary then
			-- Simple single-item layout
			icon_item = sbar.add("item", base .. suffix, {
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
					y_offset = 4,
					padding_left = 0,
					padding_right = 0,
				},
				click_script = click_cmd,
			})
			primary = icon_item
		else
			-- Three-item stacked layout (mirrors wifi_up / wifi_down)
			-- 1. Icon-only item — reserves the horizontal space and shows the glyph
			icon_item = sbar.add("item", base .. ".icon" .. suffix, {
				display = display_index,
				position = position,
				drawing = true,
				icon = {
					string = app_icons[app_name] or "?",
					font = "sketchybar-app-font:Regular:16.0",
					color = colors.white,
					padding_left = 4,
				},
				label = { drawing = false },
				click_script = click_cmd,
			})

			-- 2. Primary count label — width=0 so it overlaps the icon item
			primary = sbar.add("item", base .. suffix, {
				display = display_index,
				position = position,
				drawing = true,
				width = 0,
				padding_left = -5,
				icon = { drawing = false },
				label = {
					string = "",
					font = "FiraCode Nerd Font:Bold:10.0",
					color = colors.red,
					y_offset = 4,
					padding_left = 0,
					padding_right = 0,
				},
				click_script = click_cmd,
			})

			-- 3. Secondary count label — sits below the primary via y_offset=-4
			secondary = sbar.add("item", base .. ".secondary" .. suffix, {
				display = display_index,
				position = position,
				drawing = false,
				padding_left = -5,
				icon = { drawing = false },
				label = {
					string = "",
					font = "FiraCode Nerd Font:Bold:10.0",
					color = colors.yellow,
					y_offset = -4,
					padding_left = 0,
					padding_right = 0,
				},
				click_script = click_cmd,
			})
		end

		app_items[app_name] = { icon = icon_item, primary = primary, secondary = secondary }
		return app_items[app_name]
	end

	-- Separate apps into those that use Dock badges vs. custom count commands.
	-- An app with count_command2 but no count_command still uses the Dock for
	-- the primary count; it just also fires a second async call.
	local dock_apps = {}
	local custom_count_apps = {}
	local secondary_count_apps = {}
	for _, entry in ipairs(apps_to_track) do
		local e = normalize(entry)
		if e.count_command then
			table.insert(custom_count_apps, e)
		else
			table.insert(dock_apps, e)
		end
		if e.count_command2 then
			table.insert(secondary_count_apps, e)
		end
	end

	-- Built once at load time, reused on every update tick (only for Dock-badge apps)
	local function build_osascript_cmd(app_list)
		if #app_list == 0 then
			return nil
		end

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

	local OSASCRIPT_CMD = build_osascript_cmd(dock_apps)

	-- Pre-create all items so the bracket can include them from the start.
	for _, entry in ipairs(apps_to_track) do
		get_or_create_item(entry)
	end

	sbar.delay(1, function()
		local order_cmd = "sketchybar --reorder"

		-- Returns item names in render order for an entry.
		-- For the "q" (left/builtin) position items flow right-to-left, so we put
		-- the zero-width label items BEFORE the icon item so they land on top of it.
		-- For center/right positions the icon comes first as normal.
		local function item_names_for(entry)
			local name = normalize(entry).name
			local safe_name = name:gsub("%s+", "_"):lower()
			local base = "items.notifications." .. safe_name
			local handles = app_items[name]
			local names = {}
			if handles and handles.secondary then
				if position == "q" then
					-- Right-to-left flow: labels first, then icon
					table.insert(names, base .. suffix)
					table.insert(names, base .. ".secondary" .. suffix)
					table.insert(names, base .. ".icon" .. suffix)
				else
					-- Left-to-right flow: icon first, then labels
					table.insert(names, base .. ".icon" .. suffix)
					table.insert(names, base .. suffix)
					table.insert(names, base .. ".secondary" .. suffix)
				end
			else
				table.insert(names, base .. suffix)
			end
			return names
		end

		if position == "center" then
			-- Reverse order for center position since sketchybar mirrors it
			for i = #apps_to_track, 1, -1 do
				for _, n in ipairs(item_names_for(apps_to_track[i])) do
					order_cmd = order_cmd .. " " .. n
				end
			end
			order_cmd = order_cmd .. " " .. notifications.name
		else
			order_cmd = order_cmd .. " " .. notifications.name
			for _, entry in ipairs(apps_to_track) do
				for _, n in ipairs(item_names_for(entry)) do
					order_cmd = order_cmd .. " " .. n
				end
			end
		end

		sbar.exec(order_cmd)
	end)

	-- Bracket wraps all items into one visual pill.
	local bracket_members = { notifications.name }
	for _, entry in ipairs(apps_to_track) do
		local name = normalize(entry).name
		local safe_name = name:gsub("%s+", "_"):lower()
		local base = "items.notifications." .. safe_name
		local handles = app_items[name]
		if handles and handles.secondary then
			if position == "q" then
				table.insert(bracket_members, base .. suffix)
				table.insert(bracket_members, base .. ".secondary" .. suffix)
				table.insert(bracket_members, base .. ".icon" .. suffix)
			else
				table.insert(bracket_members, base .. ".icon" .. suffix)
				table.insert(bracket_members, base .. suffix)
				table.insert(bracket_members, base .. ".secondary" .. suffix)
			end
		else
			table.insert(bracket_members, base .. suffix)
		end
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
	local last_counts = {}

	local function set_app_items_visible(visible)
		for _, entry in ipairs(apps_to_track) do
			local handles = get_or_create_item(entry)
			local app_name = normalize(entry).name
			if handles.secondary then
				-- Three-item layout: toggle icon and primary together
				handles.icon:set({ drawing = visible })
				handles.primary:set({ drawing = visible })
				local sec_count = last_counts[app_name .. ":secondary"] or 0
				handles.secondary:set({ drawing = visible and sec_count > 0 })
			else
				handles.primary:set({ drawing = visible })
			end
		end
	end

	notifications:subscribe("mouse.clicked", function()
		expanded = not expanded
		set_app_items_visible(expanded)
	end)
	-- ─────────────────────────────────────────────────────────────────────────

	-- Apply a resolved counts table to all items and update the total badge.
	-- Secondary counts are stored under the key "<AppName>:secondary".
	local function apply_counts(app_counts)
		last_counts = app_counts

		local total = 0
		for key, count in pairs(app_counts) do
			-- Only sum primary counts (not ":secondary" keys) into the total badge
			if not key:match(":secondary$") then
				total = total + count
			end
		end

		for _, entry in ipairs(apps_to_track) do
			local app_name = normalize(entry).name
			local handles = get_or_create_item(entry)
			local count = app_counts[app_name] or 0
			local sec_count = app_counts[app_name .. ":secondary"] or 0

			if handles.secondary then
				-- Three-item layout: icon colour changes independently
				if count > 0 then
					handles.icon:set({ drawing = expanded, icon = { color = colors.white } })
					handles.primary:set({ drawing = expanded, label = { string = tostring(count), color = colors.red } })
				else
					handles.icon:set({ icon = { color = colors.grey } })
					handles.primary:set({ label = { string = "" } })
				end

				if sec_count > 0 then
					handles.secondary:set({
						drawing = expanded,
						label = { string = tostring(sec_count), color = colors.yellow },
					})
				else
					handles.secondary:set({ drawing = false, label = { string = "" } })
				end
			else
				-- Simple single-item layout
				if count > 0 then
					handles.primary:set({
						drawing = expanded,
						icon = { color = colors.white },
						label = { string = tostring(count), color = colors.red },
					})
				else
					handles.primary:set({
						icon = { color = colors.grey },
						label = { string = "", color = colors.grey },
					})
				end
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
	end

	-- Main update function
	local function update_notifications()
		local app_counts = {}
		local pending = #custom_count_apps + #secondary_count_apps + (OSASCRIPT_CMD and 1 or 0)

		local function maybe_apply()
			pending = pending - 1
			if pending == 0 then
				apply_counts(app_counts)
			end
		end

		-- Fire one shell command per app that has a custom count_command.
		for _, entry in ipairs(custom_count_apps) do
			local app_name = entry.name
			sbar.exec(entry.count_command, function(result)
				local count = tonumber((result or ""):match("%d+")) or 0
				app_counts[app_name] = count
				maybe_apply()
			end)
		end

		-- Fire secondary count commands (stored under "<AppName>:secondary").
		for _, entry in ipairs(secondary_count_apps) do
			local app_name = entry.name
			sbar.exec(entry.count_command2, function(result)
				local count = tonumber((result or ""):match("%d+")) or 0
				app_counts[app_name .. ":secondary"] = count
				maybe_apply()
			end)
		end

		-- Fire the single osascript call for all remaining Dock-badge apps.
		if OSASCRIPT_CMD then
			sbar.exec(OSASCRIPT_CMD, function(result)
				local dock_counts = parse_app_counts(result or "")
				for k, v in pairs(dock_counts) do
					app_counts[k] = v
				end
				maybe_apply()
			end)
		end
	end

	-- Subscribe to periodic and forced updates
	notifications:subscribe("routine", update_notifications)
	notifications:subscribe("forced", update_notifications)

	update_notifications()
end

for i = 1, display.count do
	if not display.is_narrow(i, 1800) then
		setup_for_display(i)
	end
end
