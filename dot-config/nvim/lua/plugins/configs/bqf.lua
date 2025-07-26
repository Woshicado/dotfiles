return {
	"kevinhwang91/nvim-bqf",
	event = "BufWinEnter quickfix",
	config = function()
		require("bqf").setup({
			auto_enable = true,
		})
	end,
}

