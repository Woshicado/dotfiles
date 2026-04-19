local last_color = "Coral"

local function color_surround(color)
	return {
		add = function()
			return {
				{ string.format('<font color="%s">', color) },
				{ "</font>" },
			}
		end,
	}
end

-- Helper to set up a surround with a given color and update last_color
local function make_color_surround(color)
	last_color = color
	require("nvim-surround").buffer_setup({
		surrounds = {
			["f"] = color_surround(color),
		},
	})
end

-- Surround with a preset color menu
vim.keymap.set("n", "<localleader>sc", function()
	local colors = { "Coral", "Crimson", "DodgerBlue", "MediumSeaGreen", "Gold", "Orchid" }
	vim.ui.select(colors, { prompt = "Select color:" }, function(choice)
		if choice then
			make_color_surround(choice)
			vim.notify('Font color set to "' .. choice .. '". Use Sf to surround.', vim.log.levels.INFO)
		end
	end)
end, { buffer = true, desc = "Select font color for surround" })

-- Surround with a custom color (prompted)
vim.keymap.set("n", "<localleader>sC", function()
	vim.ui.input({ prompt = "Enter color: ", default = last_color }, function(input)
		if input and input ~= "" then
			make_color_surround(input)
			vim.notify('Font color set to "' .. input .. '". Use Sf to surround.', vim.log.levels.INFO)
		end
	end)
end, { buffer = true, desc = "Enter custom font color for surround" })

-- Initialize with the default/last color
make_color_surround(last_color)
