return {
	"gbprod/yanky.nvim",
	event = "VeryLazy",
	keys = {
		{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Yanky put after" },
		{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Yanky put before" },
		{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Yanky gput after" },
		{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Yanky gput before" },
		{ "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Yanky previous entry" },
		{ "<C-n>", "<Plug>(YankyNextEntry)", desc = "Yanky next entry" },
		{ "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Yanky put indent after linewise" },
		{ "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Yanky put indent before linewise" },
		{ "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Yanky put indent after linewise" },
		{ "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Yanky put indent before linewise" },
	},
	config = function()
		require("yanky").setup({
			ring = {
				history_length = 100,
				storage = "shada",
				sync_with_numbered_registers = true,
			},
			system_clipboard = {
				sync_with_ring = true,
			},
			highlight = {
				timer = 200,
			},
		})
	end,
}
