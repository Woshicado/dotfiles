return {
	"christoomey/vim-tmux-navigator",
	-- stylua: ignore start
	keys = {
		{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Window left" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Window right" },
		{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Window down" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Window up" },
	},
	-- stylua: ignore end
	cmd = { "TmuxNavigateLeft", "TmuxNavigateRight", "TmuxNavigateDown", "TmuxNavigateUp" },
}
