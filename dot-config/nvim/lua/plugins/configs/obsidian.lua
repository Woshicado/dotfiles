return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"ibhagwan/fzf-lua",
	},
	cmd = {
		"Obsidian",
	},
	opts = {
		legacy_commands = false,
		-- TODO: We need this on mac for now to gen the frontmatter from templates. But this is a bug.
		-- Disable at some point later; see https://github.com/obsidian-nvim/obsidian.nvim/issues/801
		frontmatter = { enabled = true },
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
		checkbox = {
			enabled = true,
			create_new = false,
			order = { " ", "~", "!", ">", "x" },
		},
		footer = {
			enabled = true,
			format = "{{backlinks}} backlinks  {{properties}} properties  {{words}} words  {{chars}} chars",
			hl_group = "Comment",
			separator = string.rep("-", 80),
		},
		picker = {
			name = "fzf-lua",
			note_mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
			tag_mappings = {
				tag_note = "<C-x>",
				insert_tag = "<C-l>",
			},
		},
	},
	-- stylua: ignore start
	keys = {
		{ "<leader>on", "<cmd>Obsidian template note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", desc = "Obsidian Note template" },
		{ "<leader>od", "<cmd>Obsidian today<CR>", desc = "Obsidian Daily" },
		{ "<leader>ot", "<cmd>Obsidian tags<CR>", desc = "Obsidian Tags" },
		-- { "<leader>os", function() require("fzf-lua").files({ cwd = vim.env.O_VAULT_DIR }) end, desc = "Find in obsidian" },
		-- { "<leader>oz", function() vim.cmd('FzfLua live_grep cwd=vim.env.O_VAULT_DIR') end, desc = "Grep in obsidian" },
		{ "<leader>os", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian Search" },  -- NOTE: Testing. Same as above?
		{ "<leader>oz", "<cmd>Obsidian search<cr>", desc = "Obsidian FuZzy" },  -- NOTE: Testing. Same as above?
	},
	-- stylua: ignore end
	config = function(_, opts)
		require("obsidian").setup(opts)
		vim.keymap.set("n", "gd", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>Obsidian follow_link<CR>"
			else
				return "gd"
			end
		end, { noremap = false, expr = true })
	end,
}
