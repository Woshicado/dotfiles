return {
	"yousefhadder/markdown-plus.nvim",
	-- Local working copy at ~/projects/markdown-plus.nvim, on branch
	-- feat/quote-continuation. Drop `dev` to go back to upstream.
	dev = true,
	ft = "markdown",
	opts = {
		enabled = true,

		features = {
			list_management = true,
			text_formatting = true,
			thematic_break = true,
			links = true,
			images = true,
			headers_toc = true,
			quotes = true,
			callouts = true,
			code_block = true,
			html_block_awareness = true,
			table = true,
			footnotes = true,
		},

		keymaps = {
			enabled = true,
		},

		filetypes = { "markdown" },

		toc = {
			initial_depth = 2,
		},

		thematic_break = {
			style = "---", -- "---" | "***" | "___"
		},

		callouts = {
			default_type = "NOTE",
			custom_types = {},
		},

		code_block = {
			enabled = true,
			fence_style = "backtick", -- "backtick" | "tilde"
			languages = { "lua", "python", "javascript", "typescript", "bash", "json", "yaml", "markdown" },
		},

		table = {
			enabled = true,
			auto_format = true,
			default_alignment = "left",
			confirm_destructive = true,
			width_mode = "literal", -- "literal" | "segment"  set "segment" so cells
			-- containing <br> don't inflate column width
			wrap_break = "<br>", -- token used by wrap/break commands and the
			-- cell-editor popup join
			max_column_width = nil, -- integer ≥ 1 or nil  width used by wrap-cell
			-- and auto-wrap; nil prompts each time
			auto_wrap = false, -- when true (and max_column_width is set), the
			-- formatter auto-wraps cells exceeding the cap.
			-- Per-table opt-out: place
			-- <!-- markdown-plus: no-wrap --> on the line
			-- immediately above the table
			cell_editor = { -- floating popup for <localleader>te
				enabled = true,
				border = "rounded", -- nvim_open_win border style
				width = 0.6, -- fraction of editor width, (0, 1]
				height = 0.4, -- fraction of editor height, (0, 1]
			},
			keymaps = {
				enabled = true,
				prefix = "<localleader>t",
				insert_mode_navigation = true,
			},
		},

		footnotes = {
			section_header = "Footnotes",
			confirm_delete = true,
		},

		list = {
			smart_outdent = true,
			whitespace = "single", -- "single" | "shiftwidth"
			-- "single" (default): one space after the marker (standard Markdown)
			-- "shiftwidth": pad so content aligns to a whitespace_width column block (relative to the item's indent)
			-- Note: formatters like Prettier enforce single-space and will override this on save.
			whitespace_width = 4, -- integer ≥ 1; block width used when whitespace = "shiftwidth"
			checkbox_completion = {
				enabled = false,
				format = "emoji", -- "emoji" | "comment" | "dataview" | "parenthetical"
				date_format = "%Y-%m-%d",
				remove_on_uncheck = true,
				update_existing = true,
			},
		},

		links = {
			smart_paste = {
				enabled = false,
				timeout = 5, -- 1..30
			},
		},

		quote = {
			continuation = true, -- carry `>` onto lines made with <CR>/o/O; on an
			-- empty quote <CR> peels one nesting level per press
		},
	},
}
