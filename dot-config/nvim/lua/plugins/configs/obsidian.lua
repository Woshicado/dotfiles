return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		frontmatter = { enabled = false },
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
	keys = {
		{ "<leader>on", "...", desc = "Insert obsidian note template" },
		{ "<leader>od", "<cmd>ObsidianToday<CR>", desc = "Open today's daily note" },
		{ "<leader>os", function() require("fzf-lua").files({ cwd = "$O_VAULT_DIR" }) end, desc = "Find in obsidian" },
		{ "<leader>oz", function() vim.cmd('FzfLua live_grep cwd="$O_VAULT_DIR"') end, desc = "Grep in obsidian" },
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
