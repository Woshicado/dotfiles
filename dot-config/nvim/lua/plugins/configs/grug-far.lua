return {
	"MagicDuck/grug-far.nvim",
	keys = { '<leader>fs' },
  cmd = { "GrugFar" },
	config = function()
		require("grug-far").setup({})
	end,
}
