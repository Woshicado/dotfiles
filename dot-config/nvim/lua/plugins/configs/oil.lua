return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- cmd = { "Oil" },
	lazy = false,
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Oil", mode = { "n" } },
  },
	config = function()
		require("oil").setup({
			use_default_keymaps = false,
			keymaps = {
				["g?"] = { "actions.show_help", mode = "n" },
				["<CR>"] = "actions.select",
				["<leader>s"] = { "actions.select", opts = { vertical = true } },
				["<leader>h"] = { "actions.select", opts = { horizontal = true } },
				["<C-t>"] = { "actions.select", opts = { tab = true } },
				["<C-p>"] = "actions.preview",
				["<C-c>"] = { "actions.close", mode = "n" },
				["<leader>rr"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				-- ["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["g\\"] = { "actions.toggle_trash", mode = "n" },
				["gs"] = { -- open GrugFar with the current directory as the search path
					callback = function()
						-- get the current directory
						local prefills = { paths = require("oil").get_current_dir() }

						local grug_far = require("grug-far")
						-- instance check
						if not grug_far.has_instance("explorer") then
							grug_far.open({
								instanceName = "explorer",
								prefills = prefills,
								staticTitle = "Find and Replace from Explorer",
							})
						else
							grug_far.get_instance("explorer"):open()
							-- updating the prefills without clearing the search and other fields
							grug_far.get_instance("explorer"):update_input_values(prefills, false)
						end
					end,
					desc = "oil: Search in directory",
				},
			},
			columns = {
				{ "permissions", highlight = "Special" },
				"icon",
				-- "size",
				-- "mtime",
			},
			constrain_cursor = "name",
		})
	end,
}
