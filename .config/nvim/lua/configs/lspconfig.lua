-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- EXAMPLE
local servers = { "html", "cssls", "ts_ls", "clangd", "ltex", "marksman" }
local nvlsp = require("nvchad.configs.lspconfig")

-- Local dictionary
local words = {}
for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
	table.insert(words, word)
end

-- Custom Server Settings

local server_settings = {
	ltex = {
		ltex = {
			dictionary = {
				["en-US"] = words,
			},
			enabled = { "bibtex", "gitcommit", "org", "tex", "restructuredtext", "rsweave", "latex", "quarto", "rmd", "context", "mail", "plaintext" },
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
	-- pylsp = {
	-- 	pylsp = {
	-- 		plugins = {
	-- 			pycodestyle = { enabled = false },
	-- 			jedi_completion = { fuzzy = true },
	-- 			mccabe = { enabled = false },
	-- 			mypy = { enabled = false },
	-- 			isort = { enabled = false },
	-- 			spyder = { enabled = false },
	-- 			autopep8 = { enabled = false },
	-- 			memestra = { enabled = false },
	-- 			flake8 = { enabled = false },
	-- 			pyflakes = { enabled = false },
	-- 			yapf = { enabled = false },
	-- 			rope = { enabled = false },
	-- 			preload = { enabled = false },
	-- 			pydocstyle = { enabled = false },
	-- 			pylint = { enabled = false },
	-- 		},
	-- 		filetypes = { "python" },
	-- 	},
	-- },
	-- ruff = {
	-- 	format = { "I" },
	-- 	extendSelect = { "I" },
	-- },
}

-- lsps with custom server config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
		settings = server_settings[lsp],
	})
end

local venv = os.getenv("VIRTUAL_ENV")
local python_path = venv and venv .. "/bin/python" or "python3"

lspconfig.pylsp.setup({
	on_attach = function(client, bufnr)
		-- client.capabilities.diagnosticProvider = false -- Disable diagnostics from pylsp
		-- client.server_capabilities.signatureHelpProvider = false
		-- client.server_capabilities.hoverProvider = true
		nvlsp.on_attach(client, bufnr)
	end,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = { enabled = false },
				jedi_completion = { fuzzy = true },
				mccabe = { enabled = false },
				pylsp_mypy = {
					enabled = true,
					-- dmypy = true,
					live_mode = true, -- Enable live mode for Mypy
					report_progress = true, -- Report progress for Mypy
					overrides = { "--python-executable", python_path, "--ignore-missing-imports", true }, -- Use the virtual environment's Python executable
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
					ignore = { "TD002", "TD003", "PD901" }, -- Example ignores, adjust as needed
					format = { "I" },
					extendSelect = { "I" },
					severities = {
						["FIX002"] = "W",
						["ARG002"] = "I",
					},
				},
			},
			filetypes = { "python" },
		},
	},
})

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true } })

-- lspconfig.ruff.setup({
-- 	on_attach = function(client, bufnr)
-- 		-- Disable Ruff's references and definitions if it's interfering
-- 		client.server_capabilities.referencesProvider = false
-- 		client.server_capabilities.definitionProvider = false
-- 		nvlsp.on_attach(client, bufnr)
-- 	end,
-- 	on_init = nvlsp.on_init,
-- 	capabilities = nvlsp.capabilities,
-- 	settings = server_settings.ruff,
-- })

-- lspconfig.pyright.setup({
--   name = "pyright_completions",
--   root_dir = lspconfig.util.root_pattern(".git", "pyproject.toml"),
--   settings = {},
--
--   -- Only attach completion capability
--   on_attach = function(client, bufnr)
--     client.server_capabilities.documentFormattingProvider = false
--     client.server_capabilities.documentRangeFormattingProvider = false
--     client.server_capabilities.hoverProvider = false
--     client.server_capabilities.definitionProvider = false
--     client.server_capabilities.renameProvider = false
--     client.server_capabilities.referencesProvider = false
--     client.server_capabilities.codeActionProvider = false
--     client.server_capabilities.signatureHelpProvider = false
--     client.server_capabilities.documentSymbolProvider = false
--     client.server_capabilities.workspaceSymbolProvider = false
--     client.server_capabilities.semanticTokensProvider = nil
--   end,
-- })
