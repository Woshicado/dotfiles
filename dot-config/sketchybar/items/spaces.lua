local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- AeroSpace workspaces, not macOS Mission Control spaces.

local AEROSPACE = "/opt/homebrew/bin/aerospace"

local spaces = {}    -- workspace name -> { item, bracket, padding }
local order = {}     -- workspace names, in display order

-- Numbers first (numerically), then letters (alphabetically), so 2 < 10 < B.
local function workspace_lt(a, b)
  local na, nb = tonumber(a), tonumber(b)
  if na and nb then return na < nb end
  if na then return true end
  if nb then return false end
  return a < b
end

local function add_workspace(name)
  if spaces[name] then return spaces[name] end

  local item = sbar.add("item", "space." .. name, {
    drawing = false,
    icon = {
      font = { family = settings.font.numbers },
      string = name,
      padding_left = 15,
      padding_right = 8,
      color = colors.white,
      highlight_color = colors.red,
      y_offset = -1,
    },
    label = {
      padding_right = 20,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = 0,
    },
    padding_right = 1,
    padding_left = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 26,
      border_color = colors.black,
    },
  })

  -- Single-item bracket, to get the double border on highlight.
  local bracket = sbar.add("bracket", { item.name }, {
    drawing = false,
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2,
    },
  })

  local padding = sbar.add("item", "space.padding." .. name, {
    drawing = false,
    script = "",
    width = settings.group_paddings,
  })

  -- Left/right/middle all just focus it
  item:subscribe("mouse.clicked", function(_)
    sbar.exec(AEROSPACE .. " workspace " .. name)
  end)

  spaces[name] = { item = item, bracket = bracket, padding = padding }
  return spaces[name]
end

local function set_visible(entry, visible, focused)
  entry.item:set({
    drawing = visible,
    icon = { highlight = focused },
    label = { highlight = focused },
    background = { border_color = focused and colors.black or colors.bg2 },
  })
  entry.bracket:set({
    drawing = visible,
    background = { border_color = focused and colors.grey or colors.bg2 },
  })
  entry.padding:set({ drawing = visible })
end

local function icon_line_for(apps)
  if not apps or #apps == 0 then return " —" end
  local line = ""
  for _, app in ipairs(apps) do
    local lookup = app_icons[app]
    line = line .. ((lookup == nil) and app_icons["Default"] or lookup)
  end
  return line
end

local function update()
  -- One call for every window on every monitor:
  -- `<workspace>|<layout>|<app name>`.
  sbar.exec(AEROSPACE .. " list-windows --monitor all --format '%{workspace}|%{window-layout}|%{app-name}'",
    function(windows_out)
      sbar.exec(AEROSPACE .. " list-workspaces --focused", function(focused_out)
        local focused = focused_out and focused_out:match("^%s*(.-)%s*$") or ""

        -- Only tiled windows count, for both the icons and for whether the
        -- workspace is shown at all. Floating windows are summoned to whatever
				-- workspace I am on, so they are effectively available everywhere

        -- Whitelist the tiled layouts rather than blacklisting "floating":
        -- AeroSpace also reports states like `macos_native_window_of_hidden_app`
        -- and `macos_native_fullscreen`, which are equally not-in-the-layout.
        -- Tiled windows always report h_/v_ + tiles/accordion.
        local apps = {}
        for line in (windows_out or ""):gmatch("[^\r\n]+") do
          local ws, layout, app = line:match("^([^|]+)|([^|]+)|(.+)$")
          if ws and app
            and (layout:match("^[hv]_tiles$") or layout:match("^[hv]_accordion$")) then
            apps[ws] = apps[ws] or {}
            table.insert(apps[ws], app)
          end
        end

        -- A workspace can be created after load (AeroSpace makes them on
        -- demand), so pick up anything we have not seen yet.
        local seen_new = false
        for ws in pairs(apps) do
          if not spaces[ws] then add_workspace(ws); seen_new = true end
        end
        if focused ~= "" and not spaces[focused] then
          add_workspace(focused); seen_new = true
        end
        if seen_new then
          order = {}
          for ws in pairs(spaces) do table.insert(order, ws) end
          table.sort(order, workspace_lt)
        end

        for _, ws in ipairs(order) do
          local entry = spaces[ws]
          local has_windows = apps[ws] ~= nil
          local is_focused = (ws == focused)
          set_visible(entry, has_windows or is_focused, is_focused)
          if has_windows or is_focused then
            entry.item:set({ label = icon_line_for(apps[ws]) })
          end
        end
      end)
    end)
end

local handle = io.popen(AEROSPACE .. " list-workspaces --all 2>/dev/null")
if handle then
  for line in handle:lines() do
    local ws = line:match("^%s*(.-)%s*$")
    if ws ~= "" then table.insert(order, ws) end
  end
  handle:close()
end
table.sort(order, workspace_lt)
for _, ws in ipairs(order) do add_workspace(ws) end
update()

-- Fired by aerospace's exec-on-workspace-change
sbar.add("event", "aerospace_workspace_change")

local observer = sbar.add("item", { drawing = false, updates = true })
observer:subscribe("aerospace_workspace_change", update)
-- Catches windows opening, closing, or moving between workspaces, which
-- AeroSpace has no dedicated hook for.
observer:subscribe("front_app_switched", update)
observer:subscribe("system_woke", update)
