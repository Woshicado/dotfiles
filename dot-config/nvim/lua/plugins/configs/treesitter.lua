return {
	"nvim-treesitter/nvim-treesitter",
	init = function()
		require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
			local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
			local filename = vim.fn.fnamemodify(filepath, ":t")
			return string.match(filename, ".*mise.*%.toml$") ~= nil
		end, { force = true, all = false })
	end,
	opts = {
		fold = {
			fold_one_line_after = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				scope_incremental = "<S-CR>",
				node_decremental = "<BS>",
			},
		},
		ensure_installed = {
			"vim",
			"lua",
			"html",
			"css",
			"javascript",
			"typescript",
			"tsx",
			"c",
			"cpp",
			"markdown",
			"markdown_inline",
			"python",
			"json",
			"yaml",
			"xml",
			"bash",
			"bibtex",
			"latex",
		},
		indent = {
			enable = true,
			disable = {},
		},
		highlight = {
			enable = true,
			disable = { "latex", "bibtex", "mail" },
			additional_vim_regex_highlighting = { "mail" },
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
