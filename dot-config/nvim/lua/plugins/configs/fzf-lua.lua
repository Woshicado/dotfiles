return {
	"ibhagwan/fzf-lua",
	lazy = false,
	cmd = { "FzfLua" },
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},
	keys = {
		{
			"<C-x><C-f>",
			function() vim.cmd('FzfLua complete_file cmd="rg --files" winopts="{ preview = { hidden = true } }"') end,
			mode = "i",
			silent = true,
			desc = "Fuzzy complete file",
		},
		{ "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Fuzzy find files" },
		{ "<leader>fa", "<cmd>FzfLua git_files<CR>", desc = "Fuzzy find git files" },
		{ "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Fuzzy find buffers" },
		{ "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "Fuzzy find recent files" },
		{ "<leader>fr", "<cmd>FzfLua resume<CR>", desc = "Fuzzy resume" },
		{ "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Fuzzy find word in project" },
		{ "<leader>fc", "<cmd>FzfLua grep_cWORD<CR>", desc = "Fuzzy find WORD in project" },
		{ "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Fuzzy live grep in project" },
		{ "<leader>fz", "<cmd>FzfLua lgrep_curbuf<CR>", desc = "Fuzzy live current buffer" },
		{ "<leader>fm", "<cmd>FzfLua marks<CR>", desc = "Fuzzy marks" },
		{ "<leader>fp", "<cmd>FzfLua paths<CR>", desc = "Fuzzy complete path" },
		{ "<leader>fq", "<cmd>FzfLua grep_quickfix<CR>", desc = "Fuzzy quickfix list" },
		{ "<leader>fl", "<cmd>FzfLua lgrep_loclist<CR>", desc = "Fuzzy location list" },
		{ "<leader>uh", "<cmd>FzfLua undotree<CR>", desc = "Show undotree" },
		{ "<leader>uf", "<cmd>FzfLua undotree locate=false<CR>", desc = "Show undotree @location" },

		{ "<leader>gs", "<cmd>FzfLua git_stash<CR>", mode = { "n", "x" }, desc = "Fuzzy git stashes" },
		{ "<leader>gt", "<cmd>FzfLua git_status<CR>", mode = { "n", "x" }, desc = "Fuzzy git status" },
		{ "<leader>gc", "<cmd>FzfLua git_bcommits<CR>", mode = { "n", "x" }, desc = "Fuzzy git buffer commits" },
		{ "<leader>ga", "<cmd>FzfLua git_commits<CR>", mode = { "n", "x" }, desc = "Fuzzy git commits" },
		{ "<leader>gb", "<cmd>FzfLua git_branches<CR>", mode = { "n", "x" }, desc = "Fuzzy git branches" },
		{ "<leader>gl", "<cmd>FzfLua git_blame<CR>", mode = { "n", "x" }, desc = "Fuzzy git blame" },
	},
	config = function()
		local actions = require("fzf-lua").actions

		require("fzf-lua").setup({
			"border-fused",
			actions = {
				files = {
					["ctrl-q"] = actions.file_sel_to_qf,
					["alt-q"] = { fn = require("fzf-lua").actions.file_sel_to_qf, prefix = "select-all" },
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
				diff = {
					prompt = "GitDiff❯ ",
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
