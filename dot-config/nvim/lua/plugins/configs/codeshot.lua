return {
	"SergioRibera/codeshot.nvim",
	lazy = true,
	keys = {
		{ "<leader>ss", "<cmd>SSSelected<cr>", desc = "Selection Screenshot", mode = { "x" } },
		{ "<leader>sf", "<cmd>SSFocused<cr>", desc = "Focused Screenshot", mode = { "x" } },
	},
	cmd = { "SSSelected", "SSFocused" },
	config = function()
		require("codeshot").setup({
			copy = "%c",
			silent = true,
			window_controls = false,
			shadow = false,
			shadow_image = false,
			show_line_numbers = true,
			tab_width = 4,
			background = "#323232",
			radius = 30,
			author = "",
			author_color = "#FFFFFF",
			window_title = "",
			window_controls_width = 120,
			window_controls_height = 40,
			titlebar_padding = 10,
			padding_x = 0,
			padding_y = 0,
			shadow_color = "#707070",
			shadow_blur = 50,
			save_format = "png",
			output = "CodeShot_${year}-${month}-${date}_${time}.png",
		})
	end,
}
