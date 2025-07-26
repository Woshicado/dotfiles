return {
	"atiladefreitas/dooing",
	keys = { '<leader>td' },
	config = function()
		require("dooing").setup({
			save_path = vim.fn.stdpath("data") .. "/dooing_todos.json",
			timestamp = {
				enabled = true,
			},
			window = {
				width = 80,
				height = 40,
				border = "rounded",
				position = "center",
				padding = {
					top = 1,
					bottom = 1,
					left = 2,
					right = 2,
				},
			},
			formatting = {
				pending = {
					icon = "○",
					format = { "icon", "notes_icon", "text", "due_date", "ect" },
				},
				in_progress = {
					icon = "◐",
					format = { "icon", "text", "due_date", "ect" },
				},
				done = {
					icon = "✓",
					format = { "icon", "notes_icon", "text", "due_date", "ect" },
				},
			},
			quick_keys = true,
			notes = {
				icon = "📓",
			},
			scratchpad = {
				syntax_highlight = "markdown",
			},
			keymaps = {
				toggle_window = "<leader>td",
				new_todo = "i",
				toggle_todo = "x",
				delete_todo = "d",
				delete_completed = "D",
				close_window = "q",
				undo_delete = "u",
				add_due_date = "H",
				remove_due_date = "r",
				toggle_help = "?",
				toggle_tags = "t",
				toggle_priority = "<Space>",
				clear_filter = "c",
				edit_todo = "e",
				edit_tag = "e",
				edit_priorities = "p",
				delete_tag = "d",
				search_todos = "/",
				add_time_estimation = "T",
				remove_time_estimation = "R",
				import_todos = "I",
				export_todos = "E",
				remove_duplicates = "<leader>D",
				open_todo_scratchpad = "s",
				refresh_todos = "<leader>f",
				share_todos = "<leader>s",
			},
			calendar = {
				language = "en",
				icon = "",
				keymaps = {
					previous_day = "h",
					next_day = "l",
					previous_week = "k",
					next_week = "j",
					previous_month = "H",
					next_month = "L",
					select_day = "<CR>",
					close_calendar = "q",
				},
			},
			priorities = {
				{
					name = "important",
					weight = 4,
				},
				{
					name = "urgent",
					weight = 2,
				},
			},
			priority_groups = {
				high = {
					members = { "important", "urgent" },
					color = nil,
					hl_group = "DiagnosticError",
				},
				medium = {
					members = { "important" },
					color = nil,
					hl_group = "DiagnosticWarn",
				},
				low = {
					members = { "urgent" },
					color = nil,
					hl_group = "DiagnosticHint",
				},
			},
			hour_score_value = 1 / 8,
			done_sort_by_completed_time = false,
		})
	end,
}

