return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	dependencies = {},
  keys = {
    { "<C-a>", function() require("luasnip").jump(1) end,  mode = { "i", "s" }, silent = true, desc = "LuaSnip jump next" },
    { "<C-q>", function() require("luasnip").jump(-1) end, mode = { "i", "s" }, silent = true, desc = "LuaSnip jump prev" },
  },
	config = function()
		local luasnip = require("luasnip")
		luasnip.config.set_config({
			keep_roots = true,
			link_roots = true,
			exit_roots = false,
			-- TODO: Configure autosnippets. Do not apply generally as some would conflict with normal tuyping
			updateevents = "TextChanged,TextChangedI",
			cut_selection_keys = "<Tab>",
		})

		-- Load default friendly-snippets and your custom snippets
		local luasnip_loader = require("luasnip.loaders.from_vscode")
		-- luasnip_loader.lazy_load({ paths = { "~/.config/Code/User/hsnips" } })
		-- luasnip_loader.lazy_load() -- loads friendly-snippets by default
		luasnip_loader.lazy_load({ paths = { "./snippets" } })
	end,
}
