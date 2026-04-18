return {
	"stevearc/conform.nvim",
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, mode = { "n", "v" }, desc = "Format code" },
  },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				lua = { "stylua" },
				css = { "prettierd" },
				html = { "prettierd" },
				python = { "ruff_fix", "ruff_format" },
				yaml = { "yamlfix" },
				json = { "jq" },
				markdown = { "injected", "prettierd" },
				tex = { "latexindent_m" },
				toml = { "taplo" },
				java = { "google-java-format" },
				xml = { "xmlformatter" },
				sh = { "shfmt" },
			},
			opts = {
				format = {
					timeout_ms = 3000,
					async = false, -- not recommended to change
					quiet = false, -- not recommended to change
				},
			},
			formatters = {
				yamlfix = {
					env = {
						YAMLFIX_EXPLICIT_START = "false",
						YAMLFIX_WHITELINES = "1",
						YAMLFIX_COMMENTS_WHITELINES = "1",
						YAMLFIX_SECTION_WHITELINES = "1",
						YAMLFIX_LINE_LENGTH = "80",
						YAMLFIX_NONE_REPRESENTATION = "null",
						YAMLFIX_quote_basic_values = "true",
						YAMLFIX_quote_representation = '"',
						YAMLFIX_quote_keys_and_basic_values = "false",
					},
				},
				latexindent_m = {
					command = "latexindent",
					args = { "-m" },
				},
				yamlfix_frontmatter = {
					command = "bash",
					args = {
						"-c",
						[[
            awk '
              BEGIN { in_frontmatter=0 }
              /^---$/ {
                if (in_frontmatter == 0) {
                  in_frontmatter=1; print > "/tmp/frontmatter.yaml"; next
                } else {
                  in_frontmatter=2; print "---"; next
                }
              }
              {
                if (in_frontmatter == 1) print > "/tmp/frontmatter.yaml";
                else print
              }
            ' &&
            yamlfix /tmp/frontmatter.yaml > /tmp/frontmatter_fixed.yaml &&
            awk '
              BEGIN { frontmatter = 1 }
              {
                if (frontmatter) {
                  if (NR == 1) print "---"
                  print
                  if ($0 == "---") frontmatter = 0
                } else print
              }
            ' /tmp/frontmatter_fixed.yaml -
          ]],
					},
					stdin = true,
					stdout = true,
					fallback_formatter = nil,
				},
				ruff_organize_imports = {
					command = "ruff",
					args = {
						"check",
						"--force-exclude",
						"--select=I001",
						"--fix",
						"--exit-zero",
						"--stdin-filename",
						"$FILENAME",
						"-",
					},
					stdin = true,
					cwd = require("conform.util").root_file({
						"pyproject.toml",
						"ruff.toml",
						".ruff.toml",
					}),
				},
			},
			-- format_on_save = {
			--   -- These options will be passed to conform.format()
			--   timeout_ms = 500,
			--   lsp_fallback = true,
			-- },
		})
	end,
}
