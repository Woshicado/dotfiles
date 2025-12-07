return {
	"oflisback/obsidian-bridge.nvim",
	opts = {
		scroll_sync = true,
		picker = "fzf_lua",
	},
	event = {
		"BufReadPre *.md",
		"BufNewFile *.md",
	},
	lazy = true,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
