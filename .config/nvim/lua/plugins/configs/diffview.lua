return {
	"sindrets/diffview.nvim",
	command = "DiffviewOpen",
	cond = "is_git_root",
	keys = {
		{
			"<leader>gd",
			function()
				require("utils").toggle_diffview("DiffviewOpen")
			end,
			desc = "Diff Index",
		},
		{
			"<leader>gD",
			function()
				require("utils").toggle_diffview("DiffviewOpen master..HEAD")
			end,
			desc = "Diff master",
		},
		{
			"<leader>gf",
			function()
				require("utils").toggle_diffview("DiffviewFileHistory %")
			end,
			desc = "Open diffs for current File",
		},
	},
}

