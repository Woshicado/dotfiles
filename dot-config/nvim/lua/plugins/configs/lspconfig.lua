local map = vim.keymap.set

vim.lsp.log.set_level("error")

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	dependencies = { "barreiroleo/ltex_extra.nvim" },
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		local function custom_on_attach(client, bufnr)
			local function opts(desc)
				return { buffer = bufnr, desc = "LSP " .. desc }
			end

			map("n", "gd", vim.lsp.buf.definition, opts("Go to type definition"))
			map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
			map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
			map("n", "<leader>ra", vim.lsp.buf.rename, opts("Rename symbol"))
			map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions", noremap = true })

			if client.name == "ltex_plus" then
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
			"ltex_plus",
			"marksman",
			"tailwindcss",
			"jdtls",
			"pylsp",
			"lua_ls",
			"harper_ls",
			-- "GitHub Copilot",
		}

		-- Local dictionary
		local words = {}
		for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
			table.insert(words, word)
		end

		-- Make sure python venv is used
		-- local venv = os.getenv("VIRTUAL_ENV")
		-- local python_path = venv and venv .. "/bin/python" or "python3"

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
			harper_ls = {
				["harper-ls"] = {
					userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
					workspaceDictPath = "",
					fileDictPath = "",
					linters = {
						SpellCheck = true,
						SpelledNumbers = false,
						AnA = true,
						SentenceCapitalization = true,
						UnclosedQuotes = true,
						WrongQuotes = false,
						LongSentences = true,
						RepeatedWords = true,
						Spaces = true,
						Matcher = true,
						CorrectNumberSuffix = true,
					},
					codeActions = {
						ForceStable = false,
					},
					markdown = {
						IgnoreLinkTitle = false,
					},
					diagnosticSeverity = "hint",
					isolateEnglish = false,
					dialect = "American",
					maxFileLength = 120000,
					ignoredLintsPath = "",
					excludePatterns = {},
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
			ltex_plus = {
				ltex = {
					checkFrequency = "save",
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
						commands = {
							["\\texorpdfstring{}{}"] = "dummy",
							["\\right."] = "ignore",
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
						rope_autoimport = { enabled = true },
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
			local config = {
				on_attach = custom_on_attach,
				capabilities = capabilities,
				settings = server_settings[lsp],
			}
			vim.lsp.config(lsp, config)
		end

		vim.lsp.config["harper_ls"] = {
			cmd = { "harper-ls", "--stdio" },
			filetypes = { "markdown", "text", "tex", "typst", "gitcommit", "mail", "plaintext", "html" },
		}

		--[[ harper_ls stays configured but is not started automatically: it produces a lot
		     of false positives in anything that is not prose. ]]
		local opt_in = { harper_ls = true }
		vim.lsp.enable(vim.tbl_filter(function(name)
			return not opt_in[name]
		end, servers))

		vim.api.nvim_create_user_command("HarperToggle", function()
			local clients = vim.lsp.get_clients({ name = "harper_ls" })
			if #clients == 0 then
				vim.lsp.enable("harper_ls")
				vim.notify("harper_ls enabled")
				return
			end
			--[[ `vim.lsp.enable(name, false)` only drops the config from
			     lsp._enabled_configs, i.e. it stops *future* attachment -- already running
			     clients keep going, so they have to be stopped explicitly. ]]
			vim.lsp.enable("harper_ls", false)
			for _, client in ipairs(clients) do
				client:stop() -- vim.lsp.stop_client() is deprecated in 0.12
			end
			vim.notify("harper_ls disabled")
		end, { desc = "Toggle the harper_ls grammar server" })

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
