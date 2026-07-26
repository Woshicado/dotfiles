--[[ Replaces NvChad's `colorify` ]]
return {
	"nvim-mini/mini.hipatterns",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local hipatterns = require("mini.hipatterns")
		hipatterns.setup({
			highlighters = {
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})
	end,
}
