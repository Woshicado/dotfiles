return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- cmd = { "Oil" },
	lazy = false,
	config = function()
		require("oil").setup({
			columns = {
				{ "permissions", highlight = "Special" },
				"icon",
				-- "size",
				-- "mtime",
			},
      constrain_cursor = "name",
		})
	end,
}
