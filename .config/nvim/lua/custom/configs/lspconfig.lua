local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"


local words = {}
for word in io.open(vim.fn.stdpath("config") .. "/spell/en.utf-8.add", "r"):lines() do
	table.insert(words, word)
end

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "ltex" }

local server_settings = {
  ltex = {
    ltex = {
			dictionary = {
				["en-US"] = words,
			},
		},
  },
  html = {
  },
  cssls = {
  },
  clangd = {
  },
  tsserver = {
  }
}


for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = server_settings[lsp],
  }
end

-- 
-- lspconfig.pyright.setup { blabla}
