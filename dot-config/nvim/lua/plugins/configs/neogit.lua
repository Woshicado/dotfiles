return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"sindrets/diffview.nvim",
		"ibhagwan/fzf-lua",
	},
	cmd = { "Neogit" },
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Neogit", mode = { "n", "x" } },
	},
	config = function()
		require("neogit").setup({
			graph_style = "kitty",
			-- telescope_sorter = function()
			-- 	return require("telescope").extensions.fzf.native_fzf_sorter()
			-- end,
		})
	end,
}
