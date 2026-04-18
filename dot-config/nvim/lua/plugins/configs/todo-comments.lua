return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	opts = {},
	keys = {
		{ "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment", },
		{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment", },
		{ "]f", function() require("todo-comments").jump_next({ keywords = { "FIX", "HACK" } }) end, desc = "Next error/warning todo comment", },
		{ "[f", function() require("todo-comments").jump_prev({ keywords = { "FIX", "HACK" } }) end, desc = "Previous error/warning todo comment", },
	},
}
