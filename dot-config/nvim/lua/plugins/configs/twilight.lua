return {
	"folke/twilight.nvim",
  cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
	opts = {
		dimming = {
			alpha = 0.25, -- amount of dimming
			-- we try to get the foreground from the highlight groups or fallback color
			color = { "Normal", "#ffffff" },
			term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
			inactive = false, -- when true, other windows will be fully dimmed
		},
		context = 15,
		treesitter = true,
		expand = {
			"function",
			"method",
			"table",
			"if_statement",
		},
		exclude = {},
	},
}
