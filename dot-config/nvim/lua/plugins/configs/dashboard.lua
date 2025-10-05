return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				week_header = {
					enable = false,
				},
				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					{
						desc = " Files",
						group = "Label",
						action = 'require("fzf-lua").files()',
						key = "f",
					},
					{
						desc = " Obsidian",
						group = "DiagnosticHint",
						action = function()
							require("utils").open_or_create_session(os.getenv("O_VAULT_DIR"))
						end,
						key = "o",
					},
					{
						desc = " Dotfiles",
						group = "Number",
						action = function()
							require("utils").open_or_create_session(os.getenv("HOME") .. "/dotfiles")
						end,
						key = "d",
					},
					{
						desc = " Neovim",
						group = "@string",
						action = "AutoSession restore " .. os.getenv("XDG_CONFIG_HOME") .. "/nvim",
						key = "n",
					},
					{
						desc = " Sessions",
						group = "Define",
						action = "AutoSession search",
						key = "s",
					},
				},
				project = {
					enable = true,
					limit = 8,
					action = require("utils").open_or_create_session,
				},
				mru = { enable = true, limit = 10, cwd_only = false },
			},
			preview = {
				command = "cat",
				    file_path = os.getenv("HOME") .. "/.config/nvim/assets/db_text",
				file_height = 27,
				file_width = 58,
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}

