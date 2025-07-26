return {
	"ibhagwan/fzf-lua",
	lazy = false,
	cmd = { "FzfLua" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	config = function()
		local actions = require("fzf-lua").actions

		require("fzf-lua").setup({
			"border-fused",
			actions = {
				files = {
					["ctrl-q"] = actions.file_sel_to_qf,
					["ctrl-t"] = actions.toggle_ignore,
					["ctrl-h"] = actions.toggle_hidden,
					["enter"] = actions.file_edit_or_qf,
					["ctrl-s"] = actions.file_split,
					["ctrl-v"] = actions.file_vsplit,
				},
			},
			files = {
				prompt = "Files❯ ",
				formatter = "path.filename_first",
				cwd = vim.fn.expand("%:p:h"),
				git_icons = true,
				actions = {},
			},
			git = {
				files = {
					prompt = "GitFiles❯ ",
					formatter = "path.filename_first",
					cwd = vim.fn.expand("%:p:h"),
					git_icons = true,
				},
				icons = {
					["M"] = { icon = "★", color = "red" },
					["D"] = { icon = "✗", color = "red" },
					["A"] = { icon = "+", color = "green" },
				},
				status = {
					prompt = "GitStatus❯ ",
					actions = {
						-- actions inherit from 'actions.files' and merge
						["ctrl-t"] = false,
						["ctrl-h"] = false,
						["right"] = { fn = actions.git_unstage, reload = true },
						["left"] = { fn = actions.git_stage, reload = true },
						["ctrl-s"] = { fn = actions.git_stage_unstage, reload = true },
						["ctrl-x"] = { fn = actions.git_reset, reload = true },
					},
				},
				blame = {
					prompt = "Blame> ",
					cmd = [[git blame --color-lines {file}]],
					preview = "git show --color {1} -- {file}",
					-- git-delta is automatically detected as pager, uncomment to disable
					-- preview_pager = false,
					actions = {
						["enter"] = actions.git_goto_line,
						["ctrl-s"] = actions.git_buf_split,
						["ctrl-v"] = actions.git_buf_vsplit,
						["ctrl-t"] = actions.git_buf_tabedit,
						["ctrl-y"] = { fn = actions.git_yank_commit, exec_silent = true },
					},
					winopts = {
						preview = {
							hidden = true,
						},
					},
				},
			},
			-- fzf_opts = { ["--tmux"] = "center,80%,60%" },
			grep = {
				prompt = "Grep❯ ",
				git_icons = false,
			},
		})
	end,
}
