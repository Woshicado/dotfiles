local map = vim.keymap.set

vim.lsp.set_log_level("error")

return {
	"neovim/nvim-lspconfig",
	dependencies = { "barreiroleo/ltex_extra.nvim" },
	config = function()
		-- EXAMPLE
		local nvlsp = require("nvchad.configs.lspconfig")

		function custom_on_attach(client, bufnr)
			local function opts(desc)
				return { buffer = bufnr, desc = "LSP " .. desc }
			end

			map("n", "gd", vim.lsp.buf.definition, opts("Go to type definition"))
			map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
			map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
			map("n", "<leader>ra", require("nvchad.lsp.renamer"), opts("NvRenamer"))

			if client.name == "ltex" then
				require("ltex_extra").setup({
					load_langs = { "en-US", "de-DE" },
					init_check = true,
					path = vim.fn.stdpath("config") .. "/spell",
				})
			end
		end

		local servers = {
			"html",
			"cssls",
			"ts_ls",
			"clangd",
			"ltex",
			"marksman",
			"tailwindcss",
			"jdtls",
			"pylsp",
      "lua_ls",
			-- "GitHub Copilot",
		}

		-- Local dictionary
		local words = {}
		for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
			table.insert(words, word)
		end

		-- Make sure python venv is used
		local venv = os.getenv("VIRTUAL_ENV")
		local python_path = venv and venv .. "/bin/python" or "python3"

		-- Custom Server Settings
		local server_settings = {
			jdtls = {},
			tailwindcss = {
				tailwindCSS = {
					experimental = {
						classRegex = { -- react-native typescript support
							"tw`([^`]*)",
							"tw\\(([^)]*)",
							"tw\\.\\w+\\(`([^`]*)",
							"tw\\.\\w+\\(\\{([^}]*)",
						},
					},
				},
			},
			lua_ls = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } }, -- recognize `vim` global
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
			ltex = {
				ltex = {
					language = "en-US", -- default; change with '% LTeX: language=de-DE', or YAML frontmatter
					logLevel = "warn",
					dictionary = {
						["en-US"] = words,
						["de-DE"] = words,
					},
					additionalRules = {
						enablePickyRules = true, -- sent. length, passive voice, ... (disable if too many)
						motherTongue = "de-DE",
						languageModel = "~/.models/ngrams/", -- ngram models path; download from: https://languagetool.org/download/ngram-data/
					},
					latex = {
						environments = {
							tabular = "ignore",
							tabularx = "ignore",
							algorithm = "ignore",
							["algorithm*"] = "ignore",
						},
					},
					enabled = {
						"bibtex",
						"gitcommit",
						"org",
						"tex",
						"restructuredtext",
						"rsweave",
						"latex",
						"quarto",
						"rmd",
						"context",
						"mail",
						"plaintext",
						"markdown",
					},
				},
			},
			html = {},
			marksman = {},
			cssls = {},
			clangd = {},
			ts_ls = {},
			pyright = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticMode = "workspace",
						useLibraryCodeForTypes = true,
					},
				},
			},
			pylsp = {
				pylsp = {
					plugins = {
						pycodestyle = { enabled = false },
						jedi_completion = { fuzzy = true },
						mccabe = { enabled = false },
						pylsp_mypy = {
							enabled = true,
							-- dmypy = true,
							live_mode = false, -- Enable live mode for Mypy
							report_progress = true, -- Report progress for Mypy
							-- overrides = { "--python-executable", python_path, "--ignore-missing-imports" }, -- Use the virtual environment's Python executable
							-- dmypy_command = { "~/.local/share/nvim/mason/packages/python-lsp-server/venv/bin/dmypy" }
						},
						isort = { enabled = false },
						spyder = { enabled = false },
						autopep8 = { enabled = false },
						memestra = { enabled = false },
						flake8 = { enabled = false },
						pyflakes = { enabled = false },
						yapf = { enabled = false },
						rope = { enabled = false },
						preload = { enabled = false },
						pydocstyle = { enabled = false },
						pylint = { enabled = false },
						ruff = {
							enabled = true,
							formatEnabled = true,
							unsafeFixes = true,
							ignore = { "TD002", "TD003", "PD901" }, -- Example ignores, adjust as needed
							format = { "I" },
							extendSelect = { "I" },
							severities = {
								["FIX002"] = "W",
								["ARG002"] = "I",
							},
						},
					},
				},
			},
		}

		-- Configure each server
		for _, lsp in ipairs(servers) do
			config = {
				on_attach = custom_on_attach,
				on_init = nvlsp.on_init,
				capabilities = nvlsp.capabilities,
				settings = server_settings[lsp],
			}
			vim.lsp.config(lsp, config)
		end

		vim.lsp.enable(servers)

		-- Diagnostics in new line
		vim.diagnostic.config({
			-- virtual_text = true,
			virtual_lines = { current_line = true },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})
	end,
}
