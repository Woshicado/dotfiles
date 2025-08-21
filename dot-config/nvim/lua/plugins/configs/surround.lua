return {
	"kylechui/nvim-surround",
	version = "*",
	event = "VeryLazy",
	opts = {
		keymaps = {
			insert = "<C-g>s",
			insert_line = "<C-g>S",
			normal = "ys",
			normal_cur = "yss",
			normal_line = "yS",
			normal_cur_line = "ySS",
			visual = "S",
			visual_line = "gS",
			delete = "ds",
			change = "cs",
			change_line = "cS",
		},
	},
	config = function()
		local surround = require("nvim-surround")
		surround.setup({
			surrounds = {
				-- "e" -> environment
				e = {
					add = function()
						local env = vim.fn.input("environment: ")
						return {
							{ "\\begin{" .. env .. "}\n\t" }, -- opening
							{ "\n\\end{" .. env .. "}" }, -- closing
						}
					end,
				},

				-- "c" -> command
				c = {
					add = function()
						local cmd = vim.fn.input("command: ")
						return {
							{ "\\" .. cmd .. "{" }, -- opening
							{ "}" }, -- closing
						}
					end,
				},
			},
		})
	end,
}
