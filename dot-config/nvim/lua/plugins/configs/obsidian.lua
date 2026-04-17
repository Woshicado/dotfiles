return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		ui = { enable = false },
		workspaces = {
			{
				name = "personal",
				path = "~/vaults/obsidian-notes/",
			},
		},
		notes_subdir = "inbox",
		new_notes_location = "notes_subdir",
		templates = {
			subdir = "Extras/Templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
	},
	config = function(_, opts)
		require("obsidian").setup(opts)
		vim.keymap.set("n", "gd", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<CR>"
			else
				return "gd"
			end
		end, { noremap = false, expr = true })
	end,
}
