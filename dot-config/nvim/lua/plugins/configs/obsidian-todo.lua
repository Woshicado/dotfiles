return {
	url = "git@github:Woshicado/obsidian-todo.nvim.git",
	name = "obsidian-todo",
	dependencies = {
		"obsidian-nvim/obsidian.nvim",
		"nvim-lua/plenary.nvim",
	},
	cmd = "ObsidianTodo",
	keys = {
		{ "<leader>tt", desc = "Todos: toggle list" },
		{ "<leader>ta", desc = "Todos: add" },
		{ "<leader>tA", desc = "Todos: add urgent" },
		{ "<leader>to", desc = "Todos: open today's note" },
	},
	opts = {},
	config = function(_, opts)
		require("obsidian-todo").setup(opts)
	end,
}
