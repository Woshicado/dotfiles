return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				-- Treesitter highlighting for every filetype with a parser (the built-in
				-- ftplugins only do this for a handful: lua, vim, markdown, query, ...).
				pcall(vim.treesitter.start)
				-- Enable treesitter-based indentation
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})

		local ensure_installed = {
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
		}
		local already_installed = require("nvim-treesitter.config").get_installed()
		local parsers_to_install = vim.iter(ensure_installed)
			:filter(function(parser)
				return not vim.tbl_contains(already_installed, parser)
			end)
			:totable()
		require("nvim-treesitter").install(parsers_to_install)

		require("vim.treesitter.query").add_predicate("is-mise?", function(_, _, bufnr, _)
			local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
			local filename = vim.fn.fnamemodify(filepath, ":t")
			return string.match(filename, ".*mise.*%.toml$") ~= nil
		end, { force = true, all = false })
	end,
	-- highlight/indent are the FileType autocmd above,
	-- folds are nvim-ufo, incremental selection is lua/incsel.lua.
	config = function()
		require("nvim-treesitter").setup()
	end,
}
