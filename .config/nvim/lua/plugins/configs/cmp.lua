local config = require("nvchad.configs.cmp")
local cmp = require("cmp")
local luasnip = require("luasnip")

-- config.mapping["<CR>"] = cmp.mapping.confirm {
--   behavior = cmp.ConfirmBehavior.Insert,
--   select = false,
-- }

config.mapping["<CR>"] = cmp.mapping(function(fallback)
	if cmp.visible() then
		if luasnip.expandable() then
			luasnip.expand()
		elseif cmp.get_selected_entry() then
			cmp.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = false,
			})
		else
			fallback()
		end
	else
		fallback()
	end
end)

config.mapping["<Tab>"] = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.locally_jumpable(1) then
		luasnip.jump(1)
	else
		fallback()
	end
end, { "i", "s" })

config.mapping["<S-Tab>"] = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.locally_jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end, { "i", "s" })

config.completion = {
	completeopt = "menu,menuone,noselect",
}

config.preselect = cmp.PreselectMode.None

config.snippet = {
	expand = function(args)
		require("luasnip").lsp_expand(args.body)
		-- vim.snippet.expand(args.body)
	end,
}

vim.list_extend(config.sources, {
	{ name = "emoji" },
	{
		name = "latex_symbols",
		option = {
			strategy = 0, -- mixed
		},
	},
	{
		name = "cmp_yanky",
		option = {
			minLength = 3,
		},
	},
})
-- config.window = {
--   completion = cmp.config.window.bordered(),
--   documentation = cmp.config.window.bordered(),
-- }

return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"kdheepak/cmp-latex-symbols",
		"hrsh7th/cmp-emoji",
		"chrisgrieser/cmp_yanky",
		"gbprod/yanky.nvim",
		"saadparwaiz1/cmp_luasnip",
	},
	opts = config,
}
