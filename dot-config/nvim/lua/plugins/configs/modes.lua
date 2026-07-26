return {
	"mvllow/modes.nvim",
	lazy = false,
	config = function()
		require("modes").setup({
			--[[ Deliberately empty. With no colours given, modes.nvim reads the background of
			     the ModesCopy / ModesDelete / ModesFormat / ModesInsert / ModesReplace /
			     ModesVisual highlight groups, and blends them against Normal. Those groups are
			     defined from the palette in plugins/configs/kanagawa.lua. ]]
			colors = {},

			--[[ Opacity for cursorline and number background. 0.50 pushed the accent to a
			     mid-tone that swallowed the text on it  ]]
			line_opacity = 0.20,

			-- Enable cursor highlights
			set_cursor = false,

			-- Enable cursorline initially, and disable cursorline for inactive windows
			-- or ignored filetypes
			set_cursorline = false,

			-- Enable line number highlights to match cursorline
			set_number = false,

			-- Enable sign column highlights to match cursorline
			set_signcolumn = false,

			-- Disable modes highlights for specified filetypes
			-- or enable with prefix "!" if otherwise disabled (please PR common patterns)
			-- Can also be a function fun():boolean that disables modes highlights when true
			ignore = { "NvimTree", "TelescopePrompt", "!minifiles" },
		})
	end,
}
