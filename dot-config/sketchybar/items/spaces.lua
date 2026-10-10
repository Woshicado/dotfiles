local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")
local display = require("helpers.display")

-- AeroSpace workspaces, not macOS Mission Control spaces.
--
-- The list exists twice, each as one shared strip:
--   wide    ("space.w.*")  app icons with the workspace name as a small raised
--                          index, the same idiom as the notification counts.
--   compact ("space.c.*")  just the name in a keycap; only the focused workspace
--                          opens up to show its icons.
-- Every display shows exactly one of them. A display gets the wide strip unless
-- that would run into whatever comes next on its bar (the notification pill, the
-- notch, the right-hand items), which is re-checked on every update.

local AEROSPACE = "/opt/homebrew/bin/aerospace"
local APP_FONT = "sketchybar-app-font:Regular:"
local CHIP = 0xff515666
local CLEAR = 0x00000000

-- Measured widths of the wide strip's parts, used to predict its width without
-- having to draw it first. Re-measure (sketchybar --query space.w.<name>) after
-- changing the fonts or paddings below.
local WIDE = { glyph = 21, name_char = 6, pad = 10, edges = 8, margin = 8 }

local spaces = {} -- workspace name -> { w = item, c = item }
local order = {} -- workspace names, in display order
local right_min = {} -- "display-N" -> left edge of the right-hand items
local wide_on, compact_on = true, false
local wide_displays = {} -- display index -> true if it currently shows the wide strip
local assigned = nil

-- Numbers first (numerically), then letters (alphabetically), so 2 < 10 < B.
local function workspace_lt(a, b)
  local na, nb = tonumber(a), tonumber(b)
  if na and nb then return na < nb end
  if na then return true end
  if nb then return false end
  return a < b
end

-- Inner padding at either end of a strip. An item's `width` is its whole advance,
-- so the default item paddings must be zeroed or the two ends come out unequal.
local function spacer(name)
  return sbar.add("item", name, {
    drawing = false,
    width = 4,
    padding_left = 0,
    padding_right = 0,
    icon = { drawing = false },
    label = { drawing = false },
  })
end

local function add_wide(name)
  local item = sbar.add("item", "space.w." .. name, {
    drawing = false,
    padding_left = 0,
    padding_right = 0,
    icon = {
      font = APP_FONT .. "16.0",
      color = colors.grey,
      highlight_color = colors.white,
      padding_left = 6,
      padding_right = 1,
    },
    label = {
      string = name,
      font = { family = settings.font.numbers, style = settings.font.style_map["Bold"], size = 10.0 },
      color = colors.grey,
      highlight_color = colors.red,
      y_offset = 4,
      padding_left = 0,
      padding_right = 5,
    },
    background = { color = CLEAR, height = 22, corner_radius = 7, border_width = 0 },
  })
  item:subscribe("mouse.clicked", function(_)
    sbar.exec(AEROSPACE .. " workspace " .. name)
  end)
  return item
end

-- sketchybar centres a glyph by its ink width but draws it from its origin, in
-- whole points, so a character can land up to a point off centre. In SF Pro Bold
-- 11 every digit and capital ends up within half a point both ways except these,
-- which get nudged back (padding_left = -n, padding_right = n moves the glyph n
-- points right). Worked out from the font's glyph bounds; redo it for another font.
local KEYCAP_NUDGE = { ["7"] = 1 }

local function add_compact(name)
  local nudge = KEYCAP_NUDGE[name] or 0
  local item = sbar.add("item", "space.c." .. name, {
    drawing = false,
    padding_left = 2,
    padding_right = 2,
    icon = {
      string = name,
      font = { family = settings.font.text, style = settings.font.style_map["Bold"], size = 11.0 },
      color = colors.white,
      width = 18,
      align = "center",
      padding_left = -nudge,
      padding_right = nudge,
      background = { color = CHIP, height = 18, corner_radius = 5, border_width = 0 },
    },
    label = {
      drawing = false,
      font = APP_FONT .. "15.0",
      color = colors.white,
      padding_left = 5,
      padding_right = 0,
    },
  })
  item:subscribe("mouse.clicked", function(_)
    sbar.exec(AEROSPACE .. " workspace " .. name)
  end)
  return item
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

-- Bar order is creation order: the whole wide strip, then the whole compact one.
local wide_start = spacer("space.w_start")
for _, ws in ipairs(order) do spaces[ws] = { w = add_wide(ws) } end
local wide_end = spacer("space.w_end")

local compact_start = spacer("space.c_start")
for _, ws in ipairs(order) do spaces[ws].c = add_compact(ws) end
local compact_end = spacer("space.c_end")

-- One bracket per strip draws the shared pill behind it.
local function add_brackets()
  local w, c = { wide_start.name }, { compact_start.name }
  for _, ws in ipairs(order) do
    table.insert(w, spaces[ws].w.name)
    table.insert(c, spaces[ws].c.name)
  end
  table.insert(w, wide_end.name)
  table.insert(c, compact_end.name)
  sbar.add("bracket", "spaces.w.bracket", w, { background = { color = colors.bg1 } })
  sbar.add("bracket", "spaces.c.bracket", c, { background = { color = colors.bg1 } })
end
add_brackets()

-- A workspace AeroSpace created after load: append it to both strips.
local function add_workspace(name)
  spaces[name] = { w = add_wide(name), c = add_compact(name) }
  table.insert(order, name)
  table.sort(order, workspace_lt)
  sbar.exec("sketchybar --move space.w." .. name .. " before " .. wide_end.name
    .. " --move space.c." .. name .. " before " .. compact_end.name)
  sbar.remove("spaces.w.bracket")
  sbar.remove("spaces.c.bracket")
  add_brackets()
end

local function glyphs_for(apps)
  local line = ""
  for _, app in ipairs(apps or {}) do
    local lookup = app_icons[app]
    line = line .. ((lookup == nil) and app_icons["Default"] or lookup)
  end
  return line
end

-- Left edge and width of an item on one display, or nil while it is not drawn there.
local function rect_on(name, d)
  local ok, info = pcall(sbar.query, name)
  local rect = ok and type(info) == "table" and info.bounding_rects and info.bounding_rects["display-" .. d]
  if not rect or rect.origin[1] < -9000 or rect.size[1] <= 1 then return nil end
  return rect.origin[1], rect.size[1]
end

-- Before anything has been drawn there is nothing to measure, so start from a
-- guess: small, portrait and built-in displays get the compact strip.
local function guess_wide(d)
  return not (display.is_builtin(d) or display.is_portrait(d) or display.is_narrow(d, 2000))
end

-- Does a wide strip of `need` px fit on display d? nil if it cannot be measured yet.
local function wide_fits(d, need)
  -- The weather pill is the strip's left neighbour on every display.
  local x, w = rect_on("items.weather.padding", d)
  if not x then return nil end
  local start = x + w

  local limit = right_min["display-" .. d]
  if display.notifications[d] then
    local nx = rect_on(display.notifications[d], d)
    if nx and nx > start and (not limit or nx < limit) then limit = nx end
  end
  if display.is_builtin(d) then
    local notch = display.xs[d] + (display.widths[d] - 240) / 2
    if not limit or notch < limit then limit = notch end
  end
  if not limit then return nil end
  return start + need <= limit
end

-- Decide per display which strip it shows, and move the items if that changed.
local function assign_displays(need)
  local wide, compact = {}, {}
  for d = 1, display.count do
    local fits = wide_fits(d, need)
    if fits == nil then
      if wide_displays[d] == nil then fits = guess_wide(d) else fits = wide_displays[d] end
    end
    wide_displays[d] = fits
    table.insert(fits and wide or compact, d)
  end

  local key = table.concat(wide, ",") .. "|" .. table.concat(compact, ",")
  if key == assigned then return end
  assigned = key

  -- No display list at all (the query failed): show the wide strip everywhere.
  wide_on = #wide > 0 or display.count == 0
  compact_on = #compact > 0
  if #wide > 0 then
    sbar.set("/space\\.w[._].*/", { display = table.concat(wide, ",") })
  end
  if #compact > 0 then
    sbar.set("/space\\.c[._].*/", { display = table.concat(compact, ",") })
  end
end

local function update()
  -- One call for every window on every monitor:
  -- `<workspace>|<layout>|<app name>`.
  sbar.exec(AEROSPACE .. " list-windows --monitor all --format '%{workspace}|%{window-layout}|%{app-name}'",
    function(windows_out)
      -- Prefixed so a bare workspace number is not handed back parsed as JSON.
      sbar.exec("echo \"ws=$(" .. AEROSPACE .. " list-workspaces --focused)\"",
        function(focus_out)
          local focused = tostring(focus_out or ""):match("ws=([^\r\n]*)") or ""

          -- Only tiled windows count, for both the icons and for whether the
          -- workspace is shown at all. Floating windows are summoned to whatever
          -- workspace I am on, so they are effectively available everywhere
          --
          -- Whitelist the tiled layouts rather than blacklisting "floating":
          -- AeroSpace also reports states like `macos_native_window_of_hidden_app`
          -- and `macos_native_fullscreen`, which are equally not-in-the-layout.
          -- Tiled windows always report h_/v_ + tiles/accordion.
          local apps = {}
          for line in tostring(windows_out or ""):gmatch("[^\r\n]+") do
            local ws, layout, app = line:match("^([^|]+)|([^|]+)|(.+)$")
            if ws and app
              and (layout:match("^[hv]_tiles$") or layout:match("^[hv]_accordion$")) then
              apps[ws] = apps[ws] or {}
              table.insert(apps[ws], app)
            end
          end

          -- A workspace can be created after load (AeroSpace makes them on
          -- demand), so pick up anything we have not seen yet.
          for ws in pairs(apps) do
            if not spaces[ws] then add_workspace(ws) end
          end
          if focused ~= "" and not spaces[focused] then add_workspace(focused) end

          -- Predict the wide strip's width, then let each display pick its strip.
          local need = WIDE.edges + WIDE.margin
          for _, ws in ipairs(order) do
            if apps[ws] or ws == focused then
              need = need + WIDE.pad + WIDE.glyph * math.max(apps[ws] and #apps[ws] or 0, 1) + WIDE.name_char * #ws
            end
          end
          assign_displays(need)

          for _, ws in ipairs(order) do
            local entry = spaces[ws]
            local has_windows = apps[ws] ~= nil
            local is_focused = (ws == focused)
            local visible = has_windows or is_focused
            local glyphs = has_windows and glyphs_for(apps[ws]) or app_icons["Default"]

            entry.w:set({
              drawing = visible and wide_on,
              icon = { string = glyphs, highlight = is_focused },
              label = { highlight = is_focused },
              background = { color = is_focused and CHIP or CLEAR },
            })
            entry.c:set({
              drawing = visible and compact_on,
              icon = {
                color = is_focused and colors.black or colors.white,
                background = { color = is_focused and colors.red or CHIP },
              },
              label = { drawing = is_focused and has_windows, string = glyphs },
            })
          end

          wide_start:set({ drawing = wide_on })
          wide_end:set({ drawing = wide_on })
          compact_start:set({ drawing = compact_on })
          compact_end:set({ drawing = compact_on })
        end)
    end)
end

-- Where the right-hand items begin on each display. They are many, so this is
-- one background sweep rather than part of every update. sketchybar answers the
-- odd query with nothing, hence the retries, both per query and for the sweep.
local function scan_right(tries)
  tries = tonumber(tries) or 3
  sbar.exec([[q() { for _ in 1 2 3; do o=$(sketchybar --query "$1" 2>/dev/null); [ -n "$o" ] && break; sleep 0.2; done; printf '%s\n' "$o"; }
    for i in $(q bar | jq -r '.items[]'); do q "$i"; done | jq -s '
    [ .[] | select(.geometry.position == "right" and .geometry.drawing == "on") | .bounding_rects // {} | to_entries[]
      | select(.value.origin[0] > -9000 and .value.size[0] > 1) ]
    | group_by(.key) | map({ key: .[0].key, value: (map(.value.origin[0]) | min) }) | from_entries']],
    function(result)
      if type(result) == "table" and next(result) ~= nil then
        right_min = result
        update()
      elseif tries > 1 then
        sbar.delay(5, function() scan_right(tries - 1) end)
      end
    end)
end

update()
-- The first update runs before anything is drawn; measure again once it is.
sbar.delay(3, function() scan_right() end)

-- Fired by aerospace's exec-on-workspace-change
sbar.add("event", "aerospace_workspace_change")

local observer = sbar.add("item", { drawing = false, updates = true })
observer:subscribe("aerospace_workspace_change", update)
-- Catches windows opening, closing, or moving between workspaces, which
-- AeroSpace has no dedicated hook for.
observer:subscribe("front_app_switched", update)
observer:subscribe("system_woke", function() scan_right() end)
