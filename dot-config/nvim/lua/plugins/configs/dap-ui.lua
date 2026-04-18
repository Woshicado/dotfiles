return {
	"rcarriga/nvim-dap-ui",
	keys = {
		{ "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Eval expression", },
		{ "<leader>dt", function() require("dapui").toggle() end, desc = "Toggle DapUI", },
	},
	dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	config = function()
		require("dapui").setup()
	end,
}
