return {
	"rmagatti/auto-session",
	lazy = false,
	opts = {
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	},
	config = function()
		require("auto-session").setup({
			bypass_save_filetypes = { "dashboard" },
			auto_create = function()
				local cmd = "git rev-parse --is-inside-work-tree"
				return vim.fn.system(cmd) == "true\n"
			end,
			session_lens = {
				previewer = false,
				mappings = {
					delete_session = { "i", "<C-D>" },
					alternate_session = { "i", "<C-S>" },
					copy_session = { "i", "<C-Y>" },
				},
				theme_conf = {
					border = true,
				},
			},
		})
	end,
}

