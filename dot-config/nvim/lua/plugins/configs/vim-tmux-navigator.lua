return {
	"christoomey/vim-tmux-navigator",
	keys = {
		{ "<C-h>", "<cmd>TmuxNavigateLeft<CR>", desc = "Window left" },
		{ "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Window right" },
		{ "<C-j>", "<cmd>TmuxNavigateDown<CR>", desc = "Window down" },
		{ "<C-k>", "<cmd>TmuxNavigateUp<CR>", desc = "Window up" },
	},
	cmd = { "TmuxNavigateLeft", "TmuxNavigateRight", "TmuxNavigateDown", "TmuxNavigateUp" },
}
