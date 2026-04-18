return {
	"MagicDuck/grug-far.nvim",
	keys = {
		{
			"<leader>fs",
			function() require("grug-far").open() end,
			mode = { "n", "v" },
			desc = "Grug far",
		},
	},
	cmd = { "GrugFar" },
	config = function()
		require("grug-far").setup({})
	end,
}
