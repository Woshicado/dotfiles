return {
	"mfussenegger/nvim-dap",
	keys = {
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint", },
		{ "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "Run last", },
		{ "<leader>dp", function() require("dap").toggle_breakpoint(vim.fn.input("Condition: "), nil, nil) end, desc = "Toggle conditional breakpoint", },
		{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle repl", },
		{ "<leader>dh", function() require("dap.ui.widgets").hover() end, mode = { "n", "v" }, desc = "Hover", },
		{ "<leader>dw", function() local w = require("dap.ui.widgets") w.centered_float(w.scopes) end, desc = "Scopes", },
		{ "<F5>", function() require("dap").continue() end, desc = "DAP continue", },
		{ "<F10>", function() require("dap").step_over() end, desc = "DAP step over", },
		{ "<F11>", function() require("dap").step_into() end, desc = "DAP step into", },
		{ "<F12>", function() require("dap").step_out() end, desc = "DAP step out", },
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

    local last_dap_step = nil
    local function repeat_last_step()
      if last_dap_step then
        last_dap_step()
      else
        print("No previous step action")
      end
    end

    local function set_last_step(fn)
      last_dap_step = fn
      fn()
    end
    local map = vim.keymap.set

    map("n", "<leader>dn", function() set_last_step(dap.step_over) end, { desc = "Step Over", noremap = true, silent = true })
    map("n", "<leader>di", function() set_last_step(dap.step_into) end, { desc = "Step Into", noremap = true, silent = true })
    map("n", "<leader>do", function() set_last_step(dap.step_out) end, { desc = "Step Out", noremap = true, silent = true })
    map("n", "<leader>du", function() set_last_step(dap.up) end, { desc = "Step Out", noremap = true, silent = true })
    map("n", "<leader>dd", function() set_last_step(dap.down) end, { desc = "Step Out", noremap = true, silent = true })
    map("n", "<M-r>", function() repeat_last_step() end, { desc = "Repeat Last Step", noremap = true, silent = true })

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
	end,
}
