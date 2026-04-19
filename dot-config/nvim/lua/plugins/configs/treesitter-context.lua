return {
	"nvim-treesitter/nvim-treesitter-context",
	lazy = false,
	-- stylua: ignore start
	keys = {
		{ "[c", function() require("treesitter-context").go_to_context(vim.v.count1) end, silent = true, desc = "Go to context", },
	},
	-- stylua: ignore end
	config = function()
		require("treesitter-context").setup({
			enable = true,
			multiwindow = false,
			max_lines = 10,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 1,
			trim_scope = "outer",
			mode = "cursor",
			separator = "󰜥",
			zindex = 20,
			on_attach = nil,
		})
	end,
}
