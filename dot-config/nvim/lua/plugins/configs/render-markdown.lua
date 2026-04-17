return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {},
	ft = { "markdown" },
	config = function()
		require("render-markdown").setup({
			completions = { lsp = { enabled = true } },
			debounce = 100,
			render_modes = { "n", "c" },
			latex = {
				enabled = false,
			},
			heading = {
				setext = false,
				border = true,
			},
      code = {
        conceal_delimiters = false,
        -- border = 'thin',
      },
      pipe_table = {
        preset = "double",
      }
		})
	end,
}
