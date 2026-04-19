return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {},
	ft = { "markdown" },
	config = function()
		require("render-markdown").setup({
			completions = { lsp = { enabled = true } },
			debounce = 100,
			render_modes = { "n", "c" },
			latex = {
				enabled = false,
			},
			html = {
				-- Turn on / off all HTML rendering.
				enabled = true,
				-- Additional modes to render HTML.
				render_modes = false,
				comment = {
					-- Useful context to have when evaluating values.
					-- | text | text value of the comment node |

					-- Turn on / off HTML comment concealing.
					conceal = true,
					-- Text to inline before the concealed comment.
					-- Output is evaluated depending on the type.
					-- | function | `value(context)` |
					-- | string   | `value`          |
					-- | nil      | nothing          |
					text = nil,
					-- Highlight for the inlined text.
					highlight = "RenderMarkdownHtmlComment",
				},
				-- HTML tags whose start and end will be hidden and icon shown.
				-- The key is matched against the tag name, value type below.
				-- | icon            | optional icon inlined at start of tag           |
				-- | highlight       | optional highlight for the icon                 |
				-- | scope_highlight | optional highlight for item associated with tag |
				tag = {
					font = { icon = " ", highlight = "RenderMarkdownHtmlComment" },
					h1 = { icon = "󰲡 ", highlight = "RenderMarkdownH1" },
				},
			},
			heading = {
				setext = false,
				border = true,
			},
			code = {
				conceal_delimiters = false,
				-- border = 'thin',
			},
			pipe_table = {
				preset = "double",
			},
		})
	end,
}
