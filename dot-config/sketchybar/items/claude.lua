local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Claude Code attention badge.
--
-- A small icon on the right that reflects the aggregate state of every running
-- Claude Code instance. State is written per-session by the `claude_status.sh`
-- hook script into ~/.local/state/sketchybar-claude/ and aggregated here:
--   * any session "waiting"  -> red   (Claude needs your input/confirmation)
--   * else any session active -> grey  (at least one is still working)
--   * else any session "done" -> green (all sessions finished, your turn)
--   * else (no sessions)      -> hidden
-- Grey wins over green so green only appears once every agent is actually done.
--
-- The hook script fires a `claude_status` event whenever state changes; we also
-- aggregate once on load so the badge is correct after a sketchybar restart.

local STATE_DIR = os.getenv("HOME") .. "/.local/state/sketchybar-claude"

-- Claude logo glyph from the sketchybar-app-font (the ":claude:" ligature).
-- It is monochrome and tinted by the icon color, so the state colours still apply.
local ICON = app_icons["Claude"]

local claude = sbar.add("item", "items.claude", {
  position = "right",
  drawing = false,
  -- Must keep processing events even while hidden, otherwise the badge could
  -- never receive `claude_status` to un-hide itself (default is "when_shown").
  updates = "on",
  icon = {
    string = ICON,
    color = colors.grey,
    font = "sketchybar-app-font:Regular:16.0",
    padding_right = 4,
  },
  label = {
    string = "",
    drawing = false,
    color = colors.white,
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 11.0,
    },
    padding_left = 0,
  },
})

-- Read every per-session state file, tally the statuses, and update the badge.
-- Done asynchronously via sbar.exec (rather than a blocking io.popen) so the
-- bar's event loop is never stalled, even when claude_status events arrive fast.
local function render()
  sbar.exec("/bin/cat " .. STATE_DIR .. "/* 2>/dev/null", function(result)
    local text = type(result) == "string" and result or ""
    local waiting, done, working = 0, 0, 0
    for line in text:gmatch("[^\r\n]+") do
      if line == "waiting" then
        waiting = waiting + 1
      elseif line == "done" then
        done = done + 1
      elseif line == "working" then
        working = working + 1
      end
    end
    local total = waiting + done + working

    if total == 0 then
      claude:set({ drawing = false })
      return
    end

    -- Priority: red (needs input) > grey (still working) > green (all done).
    -- Grey wins over green so green only shows once every agent has finished.
    local color, attention
    if waiting > 0 then
      color = colors.red
      attention = waiting
    elseif working > 0 then
      color = colors.grey
      attention = 0
    else
      color = colors.green
      attention = done
    end

    -- Only show a count when more than one instance wants attention, to keep the
    -- badge minimal in the common single-agent case.
    local label = (attention > 1) and tostring(attention) or ""

    claude:set({
      drawing = true,
      icon = { color = color },
      label = { string = label, drawing = label ~= "" },
    })
  end)
end

claude:subscribe("claude_status", render)

-- Clicking the badge acknowledges finished (green) sessions so it resets;
-- "waiting" (red) sessions are left alone because they still need real action.
claude:subscribe("mouse.clicked", function()
  sbar.exec(
    "for f in " .. STATE_DIR .. "/*; do "
      .. '[ -f "$f" ] && grep -qx done "$f" && rm -f "$f"; '
      .. "done 2>/dev/null; true"
  )
  render()
end)

-- Initial state on (re)load.
render()
