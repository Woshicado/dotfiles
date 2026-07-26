return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local hooks = require("ibl.hooks")

		require("ibl").setup({
			indent = { char = "│" },
			scope = { char = "│" },
		})

		-- don't draw a guide at the first indent level
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
	end,
}
