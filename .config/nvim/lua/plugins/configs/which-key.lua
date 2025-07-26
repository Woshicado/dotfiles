return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({
			preset = "classic",
			delay = function(ctx)
				return ctx.plugin and 0 or 200
			end,
			filter = function(mapping)
				-- example to exclude mappings without a description
				-- return mapping.desc and mapping.desc ~= ""
				return true
			end,

			spec = {},
			notify = true,
			triggers = {
				{ "<auto>", mode = "nxso" },
			},
			defer = function(ctx)
				if vim.list_contains({ "d", "y" }, ctx.operator) then
					return true
				end
				return vim.list_contains({ "<C-V>", "V" }, ctx.mode)
			end,

			plugins = {
				marks = true, -- shows a list of your marks on ' and `
				registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
				-- the presets plugin, adds help for a bunch of default keybindings in Neovim
				-- No actual key bindings are created
				spelling = {
					enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
					suggestions = 20, -- how many suggestions should be shown in the list?
				},
				presets = {
					operators = false, -- adds help for operators like d, y, ...
					motions = false, -- adds help for motions
					text_objects = true, -- help for text objects triggered after entering an operator
					windows = true, -- default bindings on <c-w>
					nav = true, -- misc bindings to work with windows
					z = true, -- bindings for folds, spelling and others prefixed with z
					g = true, -- bindings for prefixed with g
				},
			},

			win = {
				no_overlap = true,
				-- width = 1,
				-- height = { min = 4, max = 25 },
				-- col = 0,
				-- row = math.huge,
				-- border = "none",
				padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
				title = true,
				title_pos = "center",
				zindex = 1000,
				-- Additional vim.wo and vim.bo options
				bo = {},
				wo = {
					-- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
				},
			},

			layout = {
				width = { min = 20 }, -- min and max width of the columns
				spacing = 3, -- spacing between columns
			},

			keys = {
				scroll_down = "<c-d>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},

			sort = { "local", "order", "group", "alphanum", "mod" },
			expand = 0, -- expand groups when <= n mappings

			replace = {
				key = {
					function(key)
						return require("which-key.view").format(key)
					end,
					-- { "<Space>", "SPC" },
				},

				desc = {
					{ "<Plug>%(?(.*)%)?", "%1" },
					{ "^%+", "" },
					{ "<[cC]md>", "" },
					{ "<[cC][rR]>", "" },
					{ "<[sS]ilent>", "" },
					{ "^lua%s+", "" },
					{ "^call%s+", "" },
					{ "^:%s*", "" },
				},
			},

			icons = {
				breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
				separator = "➜", -- symbol used between a key and it's label
				group = "+", -- symbol prepended to a group
				ellipsis = "…",
				mappings = true,
				rules = {},
				colors = true,
				keys = {
					Up = " ",
					Down = " ",
					Left = " ",
					Right = " ",
					C = "󰘴 ",
					M = "󰘵 ",
					D = "󰘳 ",
					S = "󰘶 ",
					CR = "󰌑 ",
					Esc = "󱊷 ",
					ScrollWheelDown = "󱕐 ",
					ScrollWheelUp = "󱕑 ",
					NL = "󰌑 ",
					BS = "󰁮",
					Space = "󱁐 ",
					Tab = "󰌒 ",
					F1 = "󱊫",
					F2 = "󱊬",
					F3 = "󱊭",
					F4 = "󱊮",
					F5 = "󱊯",
					F6 = "󱊰",
					F7 = "󱊱",
					F8 = "󱊲",
					F9 = "󱊳",
					F10 = "󱊴",
					F11 = "󱊵",
					F12 = "󱊶",
				},
			},

			show_help = true, -- show a help message in the command line for using WhichKey
			show_keys = true, -- show the currently pressed key and its label as a message in the command line

			disable = {
				ft = {},
				bt = {},
			},

			debug = false, -- enable wk.log in the current directory
		})
	end,
}
