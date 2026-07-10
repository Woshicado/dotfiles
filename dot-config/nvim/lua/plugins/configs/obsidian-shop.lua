return {
	url = "git@github:Woshicado/obsidian-shop.nvim.git",
	name = "obsidian-shop",
	dependencies = {
		"obsidian-nvim/obsidian.nvim",
		"nvim-lua/plenary.nvim",
	},
	cmd = "ObsidianShop",
	keys = {
		{ "<leader>kk", desc = "Shopping: toggle list" },
		{ "<leader>ka", desc = "Shopping: add item" },
		{ "<leader>ko", desc = "Shopping: open today's note" },
	},
	opts = {},
	config = function(_, opts)
		require("obsidian-shop").setup(opts)
	end,
}
