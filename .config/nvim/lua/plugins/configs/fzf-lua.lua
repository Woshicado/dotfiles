return {
	"ibhagwan/fzf-lua",
  cmd = { 'FzfLua' },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	config = function()
		require("fzf-lua").setup({
			"border-fused",
			files = {
				prompt = "Files❯ ",
				formatter = "path.filename_first",
				cwd = vim.fn.expand("%:p:h"),
				git_icons = true,
			},
			git = {
				icons = {
					["M"] = { icon = "★", color = "red" },
					["D"] = { icon = "✗", color = "red" },
					["A"] = { icon = "+", color = "green" },
				},
			},
			grep = {
				prompt = "Grep❯ ",
				git_icons = false,
			},
		})
	end,
}

