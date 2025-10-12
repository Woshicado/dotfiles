return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		fold = {
			fold_one_line_after = true,
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
			disable = { "latex", "bibtex" },
		},
	},
}
