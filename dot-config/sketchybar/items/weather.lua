-- ==========================================================
-- WEATHER
-- ==========================================================
local colors = require("colors")
local settings = require("settings")

position = "left"
local DEGREE = "°C" -- match your units

-- OWM condition code → icon mapping
local function get_icon(weather_id, is_day)
	if weather_id >= 200 and weather_id < 300 then
		return " " -- thunderstorm
	elseif weather_id >= 300 and weather_id < 400 then
		return " " -- drizzle
	elseif weather_id >= 500 and weather_id < 600 then
		return " " -- rain
	elseif weather_id >= 600 and weather_id < 700 then
		return "󰼶" -- snow
	elseif weather_id >= 700 and weather_id < 800 then
		return " " -- mist/fog
	elseif weather_id == 800 then
		return is_day and " " or "󰖔 " -- clear day/night
	elseif weather_id == 801 or weather_id == 802 then
		return is_day and " " or " " -- few/scattered clouds
	elseif weather_id >= 803 then
		return " " -- broken/overcast
	end
	return " "
end

local function get_icon_color(weather_id)
	if weather_id >= 200 and weather_id < 300 then
		return colors.yellow
	elseif weather_id >= 300 and weather_id < 600 then
		return colors.blue
	elseif weather_id >= 600 and weather_id < 700 then
		return colors.white
	elseif weather_id >= 700 and weather_id < 800 then
		return colors.grey
	elseif weather_id == 800 then
		return colors.yellow
	else
		return colors.white
	end
end

local weather = sbar.add("item", "weather", {
	position = position,
	icon = {
		string = "",
		font = {
			family = "FiraCode Nerd Font",
			style = "Regular",
			size = 14.0,
		},
		padding_left = 8,
		y_offset = 1,
	},
	label = {
		string = "–°C",
		padding_right = 8,
	},
	-- background = {
	-- 	color = colors.bg2,
	-- 	border_color = colors.black,
	-- 	border_width = 1,
	-- },
	padding_left = 1,
	padding_right = 1,
	update_freq = 600, -- poll every 10 minutes
})

local function update_weather()
	sbar.exec(os.getenv("HOME") .. "/.config/sketchybar/helpers/weather.sh", function(result)
		-- parse what we need with basic pattern matching (no JSON lib needed)
		local temp = result.main and result.main.temp
		local id = result.weather and result.weather[1] and result.weather[1].id
		local sunrise = result.sys and result.sys.sunrise
		local sunset = result.sys and result.sys.sunset

		if not temp or not id then
			weather:set({ label = { string = "N/A" } })
			return
		end

		local weather_id = tonumber(id)
		local now = os.time()
		local is_day = now >= tonumber(sunrise) and now < tonumber(sunset)
		local temp_str = math.floor(tonumber(temp)) .. DEGREE
		local icon = get_icon(weather_id, is_day)
		local icon_color = get_icon_color(weather_id)

		weather:set({
			icon = { string = icon, color = icon_color },
			label = { string = temp_str, color = colors.white },
		})
	end)
end

weather:subscribe("mouse.clicked", function(env)
	sbar.exec("open 'https://openweathermap.org/city'")
end)

weather:subscribe("routine", update_weather)
weather:subscribe("forced", update_weather)

sbar.add("bracket", "items.weather.bracket", { weather.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

sbar.add("item", "items.weather.padding", {
	position = position,
	width = settings.group_paddings,
})

update_weather()
