return {
	"MagicDuck/grug-far.nvim",
	keys = { '<leader>fs' },
	config = function()
		require("grug-far").setup({})
	end,
}
