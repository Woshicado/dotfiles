return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- cmd = { "Oil" },
	lazy = false,
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
				-- ["<C-l>"] = "actions.refresh",
				["-"] = { "actions.parent", mode = "n" },
				["_"] = { "actions.open_cwd", mode = "n" },
				["`"] = { "actions.cd", mode = "n" },
				["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
				["gs"] = { "actions.change_sort", mode = "n" },
				["gx"] = "actions.open_external",
				["g."] = { "actions.toggle_hidden", mode = "n" },
				["g\\"] = { "actions.toggle_trash", mode = "n" },
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
