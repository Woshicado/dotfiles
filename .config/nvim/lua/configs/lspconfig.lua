-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- EXAMPLE
local servers = { "html", "cssls", "ts_ls", "clangd", "ltex", "ruff", "marksman" }
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
				mypy = { enabled = false },
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
			},
		},
	},
	ruff = {
		format = { "I" },
		extendSelect = { "I" },
	},
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

lspconfig.pylsp.setup({
	on_attach = function(client, bufnr)
		client.capabilities.diagnosticProvider = false -- Disable diagnostics from pylsp
		nvlsp.on_attach(client, bufnr)
	end,
	on_init = nvlsp.on_init,
	capabilities = nvlsp.capabilities,
	settings = server_settings.pylsp,
})
