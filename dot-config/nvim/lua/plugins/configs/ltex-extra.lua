return {
	"barreiroleo/ltex_extra.nvim",
	dependencies = { "neovim/nvim-lspconfig" },
	config = function()
		require("ltex_extra").setup({
			client_name = "ltex_plus",
		})
	end,
}
