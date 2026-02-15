return {
	"rcarriga/nvim-dap-ui",
	keys = { "<leader>de", "<leader>dt" },
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	config = function()
		require("dapui").setup()
	end,
}
