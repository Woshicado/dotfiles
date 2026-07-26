return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000, -- must load before anything that reads its colours (lualine)
	opts = {
		compile = false, -- enable compiling the colorscheme
		undercurl = true, -- enable undercurls
		commentStyle = { italic = true, bold = true },
		functionStyle = {},
		keywordStyle = { italic = false, bold = true },
		statementStyle = { bold = true },
		typeStyle = {},
		transparent = false, -- do not set background color
		dimInactive = false, -- dim inactive window `:h hl-NormalNC`
		terminalColors = true, -- define vim.g.terminal_color_{0,17}

		colors = { -- add/modify theme and palette colors
			palette = {},
			-- Custom colours live under a `my` namespace
			theme = {
				all = {
					ui = {
						bg_gutter = "none", -- minimal
					},
					my = {
						ufo = "#7FB4CA", -- springBlue
						untracked = "#FFA066", -- surimiOrange
						unstaged = "#C0A36E", -- boatYellow2
						staged = "#98BB6C", -- springGreen
					},
				},
				lotus = {
					my = {
						ufo = "#4e8ca2", -- lotusTeal1
						untracked = "#cc6d00", -- lotusOrange
						unstaged = "#836f4a", -- lotusYellow2
						staged = "#6f894e", -- lotusGreen
					},
				},
			},
		},

		overrides = function(colors) -- add/modify highlights
			local t = colors.theme
			local my = t.my
			local color = require("kanagawa.lib.color") -- callable: color(hex) -> Color

			--[[ A colour blended most of the way into the editor background. Blending happens
			     in HSLuv, so a light background swallows the hue much faster than a dark one ]]
			local light_bg = color(t.ui.bg).L > 50
			local function tint(fg, ratio)
				return color(fg):blend(t.ui.bg, ratio or (light_bg and 0.75 or 0.88)):to_hex()
			end

			local function makeDiagnosticColor(fg)
				return { fg = fg, bg = tint(fg, 0.95) }
			end

			local hl = {
				-- Comment italics come from `commentStyle`; strings have no such option
				String = {
					fg = t.syn.string,
					italic = true,
				},

				-- Tried, but too many operators, too much red
				-- Operator = { fg = t.syn.preproc },
				-- ["@keyword.operator"] = { fg = t.syn.preproc },

				["@string.yaml"] = { fg = t.syn.string },
				["@string.value"] = { italic = true },
				["@property.yaml"] = { fg = t.syn.identifier, bold = true },

				["@markup.raw"] = { fg = t.syn.string },

				Whitespace = { fg = tint(t.ui.whitespace, 0.55) },
				IblWhitespace = { fg = tint(t.ui.whitespace, 0.55) },
				IblIndent = { fg = tint(t.ui.whitespace, 0.55) },

				-- nvim-ufo: ellipsis for folded text
				UfoVirtText = { fg = my.ufo, bg = "NONE" },

				--[[ modes.nvim was kinda illegible ]]
				ModesCopy = { bg = t.syn.identifier },
				ModesDelete = { bg = t.vcs.removed },
				ModesFormat = { bg = t.syn.type },
				ModesInsert = { bg = t.diag.ok },
				ModesReplace = { bg = t.syn.constant },
				ModesVisual = { bg = t.syn.keyword },

				--[[ render-markdown: Not all groups defined by kanagawa. So we define them here ]]
				RenderMarkdownCode = { bg = t.ui.bg_m1 },
				RenderMarkdownCodeInfo = { fg = t.syn.comment, italic = true },
				RenderMarkdownCodeInline = { fg = t.syn.string, bg = t.ui.bg_p1 },
				RenderMarkdownInlineHighlight = { fg = t.syn.string, bg = t.ui.bg_p1 },
				RenderMarkdownBullet = { fg = t.syn.special1 },
				RenderMarkdownDash = { fg = t.ui.nontext },
				RenderMarkdownQuote = { fg = t.ui.fg_dim },
				RenderMarkdownSign = { fg = t.ui.nontext, bg = "NONE" },
				RenderMarkdownIndent = { fg = t.ui.whitespace },
				RenderMarkdownMath = { fg = t.syn.constant },
				RenderMarkdownHtmlComment = { fg = t.syn.comment, italic = true },
				RenderMarkdownLink = { fg = t.syn.special1, underline = true },
				RenderMarkdownWikiLink = { fg = t.syn.special1, underline = true },
				RenderMarkdownLinkTitle = { fg = t.syn.special2 },
				RenderMarkdownUnchecked = { fg = t.ui.nontext },
				RenderMarkdownChecked = { fg = t.diag.ok, bold = true },
				RenderMarkdownTodo = { fg = t.diag.warning, bold = true },
				RenderMarkdownTableHead = { fg = t.syn.fun, bold = true },
				RenderMarkdownTableRow = { fg = t.ui.fg },

				--[[ Neogit: same as render-markdown ]]
				NeogitDiffDelete = { fg = t.vcs.removed, bg = "NONE" },
				NeogitDiffDeleteCursor = { fg = t.vcs.removed, bg = t.diff.delete },
				NeogitDiffDeletions = { fg = t.vcs.removed },
				NeogitChangeDeleted = { fg = t.vcs.removed },

				NeogitDiffContext = { bg = "NONE" },
				NeogitDiffContextHighlight = { bg = t.ui.bg_p1 },
				NeogitDiffContextCursor = { bg = t.ui.bg_p2 },

				NeogitGraphRed = { fg = t.vcs.removed },
				NeogitGraphBoldRed = { fg = t.diag.error, bold = true },

				NeogitSignatureBad = { fg = t.diag.error, bg = "NONE", bold = true },
				NeogitSignatureGoodRevokedKey = { fg = t.diag.warning, bold = true },

				NeogitChangeDuntracked = { fg = my.untracked, bg = "NONE" },
				NeogitChangeDunstaged = { fg = my.unstaged, bg = "NONE" },
				NeogitChangeDstaged = { fg = my.staged, bg = "NONE" },

				NeogitWinSeparator = { fg = t.ui.nontext, bg = "NONE" },

				---- STANDARD/COMMON CUSTOMIZATIONS FROM THE README

				--[[ Completion menu. kanagawa's own ui.pmenu is blue-tinted, which on lotus's
				     beige background reads as a foreign blue box -- so use the neutral bg_*
				     ramp instead, which is warm in lotus and dark in wave. ]]
				Pmenu = { fg = t.ui.fg, bg = t.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
				PmenuSel = { fg = "NONE", bg = t.ui.bg_p2, bold = true },
				PmenuSbar = { bg = t.ui.bg_m1 },
				PmenuThumb = { bg = t.ui.bg_p2 },

				-- Transparent Floating Windows
				NormalFloat = { bg = "none" },
				FloatBorder = { bg = "none" },
				FloatTitle = { bg = "none" },

				--[[ blink.cmp: give blink's own windows an explicit opaque background. ]]
				BlinkCmpMenu = { fg = t.ui.fg, bg = t.ui.bg_p1 },
				BlinkCmpMenuBorder = { fg = t.ui.nontext, bg = t.ui.bg_p1 },
				BlinkCmpMenuSelection = { bg = t.ui.bg_p2, bold = true },
				BlinkCmpScrollBarGutter = { bg = t.ui.bg_m1 },
				BlinkCmpScrollBarThumb = { bg = t.ui.nontext },
				BlinkCmpDoc = { fg = t.ui.fg, bg = t.ui.bg_m1 },
				BlinkCmpDocBorder = { fg = t.ui.nontext, bg = t.ui.bg_m1 },
				BlinkCmpDocSeparator = { fg = t.ui.nontext, bg = t.ui.bg_m1 },
				BlinkCmpSignatureHelp = { fg = t.ui.fg, bg = t.ui.bg_m1 },
				BlinkCmpSignatureHelpBorder = { fg = t.ui.nontext, bg = t.ui.bg_m1 },
				BlinkCmpLabelDescription = { fg = t.syn.comment },
				BlinkCmpLabelDetail = { fg = t.syn.comment },
				BlinkCmpKind = { fg = t.syn.special1 },

				NormalDark = { fg = t.ui.fg_dim, bg = t.ui.bg_m3 },

				LazyNormal = { bg = t.ui.bg_m3, fg = t.ui.fg_dim },
				MasonNormal = { bg = t.ui.bg_m3, fg = t.ui.fg_dim },

				DiagnosticVirtualTextHint = makeDiagnosticColor(t.diag.hint),
				DiagnosticVirtualTextInfo = makeDiagnosticColor(t.diag.info),
				DiagnosticVirtualTextWarn = makeDiagnosticColor(t.diag.warning),
				DiagnosticVirtualTextError = makeDiagnosticColor(t.diag.error),
			}
			--[[ syntax hues rather than diff colours, blended almost entirely into the editor bg. ]]
			local heads = {
				t.syn.fun, -- H1 blue
				t.syn.keyword, -- H2 violet
				t.syn.type, -- H3 teal
				t.syn.string, -- H4 green
				t.syn.constant, -- H5 orange
				t.syn.identifier, -- H6 yellow
			}
			for i, fg in ipairs(heads) do
				-- kanagawa links all of @markup.heading to Function, so levels need this
				hl["@markup.heading." .. i .. ".markdown"] = { fg = fg, bold = true }
				hl["RenderMarkdownH" .. i] = { fg = fg, bold = true }
				hl["RenderMarkdownH" .. i .. "Bg"] = { fg = fg, bg = tint(fg), bold = true }
			end

			return hl
		end,

		theme = "wave", -- fallback when 'background' has no mapping below
		background = { -- map the value of 'background' option to a theme
			dark = "wave", -- try "dragon" !
			light = "lotus",
		},
	},

	config = function(_, opts)
		require("kanagawa").setup(opts)
		vim.cmd.colorscheme("kanagawa")
	end,
}
