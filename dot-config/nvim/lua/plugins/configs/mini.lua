return {
	"echasnovski/mini.ai",
	event = "VeryLazy",
	config = function()
		local spec_pair = require("mini.ai").gen_spec.pair
		require("mini.ai").setup({
			-- Table with textobject id as fields, textobject specification as values.
			-- Also use this to disable builtin textobjects. See |MiniAi.config|.
			custom_textobjects = {
				["*"] = spec_pair("*", "*", { type = "greedy" }),
				["_"] = spec_pair("_", "_", { type = "greedy" }),
			},

			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				-- Main textobject prefixes
				around = "a",
				inside = "i",

				-- Next/last variants
				around_next = "",
				inside_next = "",
				around_last = "al",
				inside_last = "il",

				-- Move cursor to corresponding edge of `a` textobject
				goto_left = "g[",
				goto_right = "g]",
			},

			-- Number of lines within which textobject is searched
			n_lines = 50,

			-- How to search for object (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
			search_method = "cover_or_next",

			silent = false,
		})
	end,
}
