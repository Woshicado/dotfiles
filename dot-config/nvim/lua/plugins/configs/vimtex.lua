return {
	"lervag/vimtex",
	ft = { 'tex', 'latex', 'plaintex' },
	init = function()
		vim.g.vimtex_view_method = "skim"
		vim.g.vimtex_view_skim_sync = 1
		vim.g.vimtex_view_skim_activate = 1
		vim.g.vimtex_syntax_enabled = 1
		vim.g.vimtex_compiler_latexmk = {
			out_dir = "./out",
		}
    vim.g.vimtex_compiler_latexmk_engines = {
      _ = '-pdflatex',
      xelatex = '-xelatex',
      lualatex = '-lualatex',
    }
		vim.g.vimtex_syntax_conceal = {
			acents = 1,
			ligatures = 1,
			cites = 1,
			fancy = 1,
			spacing = 0,
			greek = 1,
			math_bounds = 1,
			math_delimiters = 1,
			math_fracs = 0,
			math_super_sub = 1,
			math_symbols = 1,
			sections = 0,
			styles = 1,
		}
		vim.g.vimtex_compiler_latexmk = {
			options = {
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
				"-shell-escape",
			},
		}
	end,
}

