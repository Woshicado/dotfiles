return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	dependencies = { "rafamadriz/friendly-snippets" },
	config = function()
		local luasnip = require("luasnip")
		luasnip.config.set_config({
			history = true,
			updateevents = "TextChanged,TextChangedI",
		})

		-- Load default friendly-snippets and your custom snippets
    local luasnip_loader = require("luasnip.loaders.from_vscode")
    luasnip_loader.lazy_load() -- loads friendly-snippets by default
		luasnip_loader.lazy_load({ paths = { "./lua/snippets" } })
	end,
}
