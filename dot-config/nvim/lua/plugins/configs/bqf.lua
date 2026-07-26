return {
	"kevinhwang91/nvim-bqf",
	event = "BufWinEnter quickfix",
	config = function()
		require("bqf").setup({
			auto_enable = true,
			-- Adapt fzf's delimiter in nvim-bqf
			filter = {
				fzf = {
					extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
				},
			},
		})
	end,
}

