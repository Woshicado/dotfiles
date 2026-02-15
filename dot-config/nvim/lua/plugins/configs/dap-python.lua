return {
	"mfussenegger/nvim-dap-python",
	ft = { "python" },
	config = function()
		require("dap-python").setup(
			"/Users/joshua/.virtualenvs/base/bin/python",
			{ console = "integratedTerminal", include_configs = false }
		)
		local dap = require("dap")
		local configs = dap.configurations.python or {}
		dap.configurations.python = configs
		table.insert(configs, {
			type = "debugpy",
			request = "launch",
			name = "Debug file",
			program = "${file}",
			console = "integratedTerminal",
			justMyCode = false,
			logToFile = true,
			showReturnValue = true,
			stopOnEntry = true,
		})

		vim.g.last_debugpy_command = vim.g.last_debugpy_command or ""

		table.insert(dap.configurations.python, {
			type = "python",
			request = "launch",
			name = "Debug custom",
			program = function()
				local parts = vim.split(vim.g.last_debugpy_command, " ")
				return parts[1]
			end,
			args = function()
				vim.g.last_debugpy_command = vim.fn.input("Command: ", vim.g.last_debugpy_command or "")
				local parts = vim.split(vim.g.last_debugpy_command, " ")
				return vim.list_slice(parts, 2)
			end,
			console = "integratedTerminal",
			justMyCode = false,
			logToFile = true,
			showReturnValue = true,
			stopOnEntry = false,
		})

		require("dap").defaults.fallback.external_terminal = {
			command = "/opt/homebrew/bin/kitty",
			args = { "--hold" },
		}
	end,
}
