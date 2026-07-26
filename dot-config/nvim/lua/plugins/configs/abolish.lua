return {
	"tpope/vim-abolish",
	lazy = false,
	init = function()
		vim.g.abolish_save_file = vim.fn.expand("~/.config/nvim/after/plugin/abolish.vim")
	end,
}

