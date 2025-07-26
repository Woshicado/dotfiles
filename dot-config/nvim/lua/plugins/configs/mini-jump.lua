return {
	"echasnovski/mini.jump",
	version = false,
	event = "VeryLazy",
	config = function()
		require("mini.jump").setup({
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				forward = "f",
				backward = "F",
				forward_till = "t",
				backward_till = "T",
				repeat_jump = ";",
			},
			delay = {
				highlight = 250,
				idle_stop = 10000000,
			},
			silent = false,
		})
	end,
}
