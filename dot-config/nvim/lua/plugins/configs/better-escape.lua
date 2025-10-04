return {
	"max397574/better-escape.nvim",
	event = "InsertEnter",
	config = function()
		require("better_escape").setup({
			timeout = vim.o.timeoutlen, -- after `timeout` passes, you can press the escape key and the plugin will ignore it
			default_mappings = false, -- false since I don't want jj mapping, other defaults are copied below
			mappings = {
				-- i for insert
				i = {
					j = {
						-- These can all also be functions
						k = "<Esc>",
						-- j = "<Esc>",  -- jj is stupid, it's jujutsu
					},
					k = {
						j = "<Esc>",
					},
				},
				c = {
					j = {
						k = "<C-c>",
						-- j = "<C-c>",
					},
				},
				t = {
					j = {
						k = "<C-\\><C-n>",
					},
				},
				v = {
					j = {
						k = "<Esc>",
					},
				},
				s = {
					j = {
						k = "<Esc>",
					},
				},
			},
		})
	end,
}
