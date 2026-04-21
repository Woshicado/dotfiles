return {
	"rmagatti/auto-session",
	lazy = false,
	opts = {
		session_lens = {
			picker = "fzf",
		},
		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	},
	config = function(_, opts)
		require("auto-session").setup(vim.tbl_deep_extend("force", opts, {
			bypass_save_filetypes = { "dashboard" },
			auto_create = function()
				local cmd = "git rev-parse --is-inside-work-tree"
				return vim.fn.system(cmd) == "true\n"
			end,
			session_lens = vim.tbl_deep_extend("force", opts.session_lens or {}, {
				previewer = false,
				mappings = {
					delete_session = { "i", "<C-D>" },
					alternate_session = { "i", "<C-S>" },
					copy_session = { "i", "<C-Y>" },
				},
				theme_conf = { border = true },
			}),
		}))
	end,
}
