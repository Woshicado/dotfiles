local colors = require("colors")
local settings = require("settings")

-- CONFIG: Match these to your Dock names
local apps_to_track = { "Mattermost", "Messages", "WhatsApp" }

local notifications = sbar.add("item", "widgets.notifications", {
	position = "right",
	icon = {
		string = "",
		font = "FiraCode Nerd Font:Bold:14.0",
		color = colors.blue,
	},
	label = {
		string = "?",
		font = "FiraCode Nerd Font:Bold:12.0",
	},
	update_freq = 5,
})

local function update_notifications()
	-- Modified AppleScript to handle "•" and other non-numeric labels
	local script = [[
        set appList to {"WhatsApp", "Mattermost", "Thunderbird"}
        set totalUnread to 0

        tell application "System Events"
          tell process "Dock"
            try
              repeat with appName in appList
                try
                  set unreadCount to value of attribute "AXStatusLabel" of UI element appName of list 1
                  if unreadCount exists then
                    try
                      set totalUnread to totalUnread + (unreadCount as integer)
                    on error
                      set totalUnread to totalUnread + 1
                    end try
                  end if
                on error errMsg
                end try
              end repeat
              return totalUnread
            on error errMsg
              return errMsg
            end try
          end tell
        end tell
    ]]

	sbar.exec("osascript -e '" .. script .. "'", function(result)
		-- Sanitize the result to ensure it's a clean number
		local count = result:gsub("%s+", "")

		notifications:set({
			drawing = true,
			label = { string = tostring(count) },
		})
    if count > 0 then
    else
      notifications:set({ drawing = false })
    end
	end)
end

notifications:subscribe("routine", update_notifications)
notifications:subscribe("forced", update_notifications)

-- Styling (Optional: makes it look like a cohesive pill)
sbar.add("bracket", "widgets.notifications.bracket", { notifications.name }, {
	background = { color = colors.bg1 },
})

sbar.add("item", "widgets.notifications.padding", {
  position = "right",
  width = settings.group_paddings,
})

update_notifications()
