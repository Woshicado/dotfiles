return {
	"gbprod/yanky.nvim",
  event = "VeryLazy",
	config = function()
		require("yanky").setup({
			ring = {
				history_length = 100,
				storage = "shada",
				sync_with_numbered_registers = true,
			},
			system_clipboard = {
				sync_with_ring = true,
			},
			highlight = {
				timer = 200,
			},
		})
	end,
}
