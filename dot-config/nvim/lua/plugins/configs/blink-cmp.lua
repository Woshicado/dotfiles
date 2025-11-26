return {
	"saghen/blink.cmp",
	event = "VeryLazy",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		-- "onsails/lspkind.nvim",
		"nvim-mini/mini.icons",
		-- "kdheepak/cmp-latex-symbols",
		-- "hrsh7th/cmp-emoji",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
		-- { "marcoSven/blink-cmp-yanky", },
		"moyiz/blink-emoji.nvim",
		{
			"Kaiser-Yang/blink-cmp-dictionary",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"micangl/cmp-vimtex",
			dependencies = {
				{
					"saghen/blink.compat",
					version = "*",
					lazy = true,
					opts = {},
				},
			},
			opts = {},
			config = function()
				require("cmp_vimtex").setup({
					additional_information = {
						info_in_menu = true,
						info_in_window = true,
						info_max_length = 60,
						match_against_info = true,
						origin_in_menu = false,
						symbols_in_menu = true,
						bib_highlighting = true,
						highlight_colors = {
							colon_group = "Normal",
							default_key_group = "PreProc",
							default_value_group = "String",
							important_key_group = "Normal",
							important_value_group = "Identifier",
						},
						highlight_links = {
							Annote = "Default",
							-- Other groups.
						},
						bibtex_parser = {
							enabled = true,
						},
						search = {
							browser = "xdg-open",
							default = "google_scholar",
							search_engines = {
								google_scholar = {
									name = "Google Scholar",
									get_url = require("cmp_vimtex").url_default_format(
										"https://scholar.google.com/scholar?hl=en&q=%s"
									),
								},
								-- Other search engines.
							},
						},
					},
				})
			end,
		},
	},
	config = function(_, opts)
		require("mini.icons").setup({
			lsp = {
				["function"] = { glyph = "󰡱" },
				array = { glyph = "󰅪" },
				color = { glyph = "" },
				constant = { glyph = "󰏿" },
				constructor = { glyph = "" },
				enum = { glyph = "" },
				event = { glyph = "󱐋" },
				file = { glyph = "" },
				folder = { glyph = "󰉋" },
				interface = { glyph = "" },
				key = { glyph = "󰌋" },
				keyword = { glyph = "󰌋" },
				method = { glyph = "󰆧" },
				-- module = { glyph = "" },
				namespace = { glyph = "󰅩" },
				object = { glyph = "󰅩" },
				snippet = { glyph = "󰩫" },
				string = { glyph = "󰉾" },
				-- text = { glyph = "" },
				typeparameter = { glyph = "󰆩" },
				value = { glyph = "󰎠" },
				-- variable = { glyph = "" },

				breakstatement = { glyph = "󰙦", hl = "MiniIconsGreen" },
				["break"] = { glyph = "󰙦", hl = "MiniIconsAzure" },
				call = { glyph = "󰃷", hl = "MiniIconsGrey" },
				calc = { glyph = "󰃬", hl = "MiniIconsOrange" },
				casestatement = { glyph = "󱃙", hl = "MiniIconsPurple" },
				codeium = { glyph = "", hl = "MiniIconsGreen" },
				continuestatement = { glyph = "→", hl = "MiniIconsAzure" },
				copilot = { glyph = "", hl = "MiniIconsGreen" },
				declaration = { glyph = "󰙠", hl = "MiniIconsYellow" },
				delete = { glyph = "", hl = "MiniIconsRed" },
				dostatement = { glyph = "󰑖", hl = "MiniIconsPurple" },
				forstatement = { glyph = "󰑖", hl = "MiniIconsPurple" },
				h1marker = { glyph = "󰉫", hl = "MiniIconsBlue" }, -- Used by markdown treesitter parser
				h2marker = { glyph = "󰉬", hl = "MiniIconsBlue" },
				h3marker = { glyph = "󰉭", hl = "MiniIconsBlue" },
				h4marker = { glyph = "󰉮", hl = "MiniIconsBlue" },
				h5marker = { glyph = "󰉯", hl = "MiniIconsBlue" },
				h6marker = { glyph = "󰉰", hl = "MiniIconsBlue" },
				identifier = { glyph = "󰀫", hl = "MiniIconsCyan" },
				ifstatement = { glyph = "󰇉", hl = "MiniIconsPurple" },
				list = { glyph = "󰅪", hl = "MiniIconsAzure" },
				log = { glyph = "", hl = "MiniIconsGrey" },
				lsp = { glyph = "", hl = "MiniIconsYellow" },
				macro = { glyph = "󰁌", hl = "MiniIconsRed" },
				markdownh1 = { glyph = "󰉫", hl = "MiniIconsBlue" }, -- Used by builtin markdown source
				markdownh2 = { glyph = "󰉬", hl = "MiniIconsBlue" },
				markdownh3 = { glyph = "󰉭", hl = "MiniIconsBlue" },
				markdownh4 = { glyph = "󰉮", hl = "MiniIconsBlue" },
				markdownh5 = { glyph = "󰉯", hl = "MiniIconsBlue" },
				markdownh6 = { glyph = "󰉰", hl = "MiniIconsBlue" },
				regex = { glyph = "", hl = "MiniIconsCyan" },
				["repeat"] = { glyph = "󰑖", hl = "MiniIconsOrange" },
				scope = { glyph = "󰅩", hl = "MiniIconsGreen" },
				specifier = { glyph = "󰦪", hl = "MiniIconsOrange" },
				statement = { glyph = "󰅩", hl = "MiniIconsYellow" },
				switchstatement = { glyph = "󰺟", hl = "MiniIconsPurple" },
				treesitter = { glyph = "", hl = "MiniIconsGreen" },
				type = { glyph = "", hl = "MiniIconsOrange" },
				whilestatement = { glyph = "󰑖", hl = "MiniIconsPurple" },

				question = { glyph = "", hl = "MiniIconsPurple" },
				hint = { glyph = "", hl = "MiniIconsGreen" },
				info = { glyph = "", hl = "MiniIconsCyan" },
				warning = { glyph = "", hl = "MiniIconsYellow" },
				error = { glyph = "", hl = "MiniIconsRed" },
				bug = { glyph = "", hl = "MiniIconsRed" },
				dict = { glyph = "󰘝", hl = "MiniIconsPurple" },
				-- emoji = { glyph = "󰞅", hl = "MiniIconsYellow" },  -- Alas emoji is coded as 'Text' kind
			},
		})
		local miniIconHLs = {
			"MiniIconsRed",
			"MiniIconsBlue",
			"MiniIconsCyan",
			"MiniIconsGrey",
			"MiniIconsAzure",
			"MiniIconsGreen",
			"MiniIconsOrange",
			"MiniIconsPurple",
			"MiniIconsYellow",
		}

		for _, hl_name in ipairs(miniIconHLs) do
			pcall(function()
				local hl_def = vim.api.nvim_get_hl_by_name(hl_name, true)
				local new_hl = { italic = true }
				if hl_def.foreground then
					new_hl.fg = string.format("#%06x", hl_def.foreground)
				end
				if hl_def.background then
					new_hl.bg = string.format("#%06x", hl_def.background)
				end
				vim.api.nvim_set_hl(0, hl_name .. "It", new_hl)
			end)
		end

		require("mini.icons").tweak_lsp_kind()
		require("blink.cmp").setup(opts)

		-- Set highlight color that isn't really set by blink.cmp
		vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#61afef", bg = "NONE", bold = true })
	end,

	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "none",
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-y>"] = { "select_and_accept", "fallback" },
			["<CR>"] = { "accept", "fallback" },

			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback_to_mappings" },
			["<C-n>"] = { "select_next", "fallback_to_mappings" },
			-- ["<S-k>"] = { "select_prev", "fallback_to_mappings" },
			-- ["<S-j>"] = { "select_next", "fallback_to_mappings" },
			["<C-k>"] = { "select_prev", "fallback_to_mappings" },
			["<C-j>"] = { "select_next", "fallback_to_mappings" },

			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-u>"] = { "scroll_documentation_up", "fallback" },
			["<C-d>"] = { "scroll_documentation_down", "fallback" },

			["<Tab>"] = { "select_next", "fallback_to_mappings", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback_to_mappings", "snippet_backward", "fallback" },
		},

		appearance = {
			highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			list = {
				selection = { preselect = false },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					max_width = 80,
					max_height = 40,
					winblend = 10,
				},
			},
			menu = {
				max_height = 20,
				scrolloff = 3,
				draw = {
					gap = 2,
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
					components = {
						kind_icon = {
							text = function(ctx)
								if require("blink.cmp.sources.lsp.hacks.tailwind").get_hex_color(ctx.item) then
									return " 󱓻" .. ctx.icon_gap .. " "
								end
								local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
								return " " .. kind_icon .. ctx.icon_gap .. " "
							end,
							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								if ctx.kind == "Color" then
									return ctx.kind_hl
								end
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl
							end,
						},
						kind = {
							text = function(ctx)
								return "<" .. ctx.kind .. ">"
								-- return "" .. ctx.kind .. ""
							end,

							-- (optional) use highlights from mini.icons
							highlight = function(ctx)
								local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
								return hl .. "It"
							end,
						},
					},
				},
			},
		},

		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = function(ctx)
						return vim.fn.getcmdtype() == ":"
					end,
				},
				ghost_text = { enabled = true },
			},
		},

		sources = {
			default = {
				"vimtex",
				"lsp",
				"path",
				"snippets",
				"buffer",
				"dictionary",
				"emoji",
			},
			providers = {
				vimtex = {
					name = "vimtex",
					min_keyword_length = 2,
					module = "blink.compat.source",
					score_offset = 100,
				},
				buffer = {
					module = "blink.cmp.sources.buffer",
					score_offset = -3,
					opts = {
						-- default to all visible buffers
						get_bufnrs = function()
							return vim.iter(vim.api.nvim_list_wins())
								:map(function(win)
									return vim.api.nvim_win_get_buf(win)
								end)
								:filter(function(buf)
									return vim.bo[buf].buftype ~= "nofile"
								end)
								:totable()
						end,
						-- buffers when searching with `/` or `?`
						get_search_bufnrs = function()
							return { vim.api.nvim_get_current_buf() }
						end,
						max_sync_buffer_size = 20000,
						max_async_buffer_size = 200000,
						max_total_buffer_size = 500000,
						retention_order = { "focused", "visible", "recency", "largest" },
						use_cache = true,
						-- Whether to enable buffer source in substitute (:s) and global (:g) commands.
						-- Note: Enabling this option will temporarily disable Neovim's 'inccommand' feature
						-- while editing Ex commands, due to a known redraw issue (see neovim/neovim#9783).
						-- This means you will lose live substitution previews when using :s, :smagic, or :snomagic
						-- while buffer completions are active.
						enable_in_ex_commands = false, -- Alas, still breaks inccommand
					},
				},
				lsp = {
					name = "LSP",
					module = "blink.cmp.sources.lsp",
					opts = { tailwind_color_icon = "󱓻" },
					async = false, -- Whether we should show the completions before this provider returns, without waiting for it
					timeout_ms = 1000, -- How long to wait for the provider to return before showing completions and treating it as asynchronous
					transform_items = function(_, items)
						local types = require("blink.cmp.types").CompletionItemKind
						return vim.tbl_filter(function(item)
							return item.kind ~= types.File and item.kind ~= types.Folder
						end, items)
					end,
					should_show_items = true,
					max_items = nil,
					min_keyword_length = 0,
					fallbacks = { "buffer" },
					score_offset = 0,
					override = nil, -- Override the source's functions
				},
				path = {
					module = "blink.cmp.sources.path",
					score_offset = 3,
					fallbacks = { "buffer" },
					opts = {
						trailing_slash = true,
						label_trailing_slash = true,
						get_cwd = function(context)
							return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
						end,
						show_hidden_files_by_default = false,
						-- Treat `/path` as starting from the current working directory (cwd) instead of the root of your filesystem
						ignore_root_slash = false,
					},
				},
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- Tune by preference
				},
				dictionary = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					score_offset = -20,
					enabled = true,
					max_items = 6,
					min_keyword_length = 3,
					opts = {
						get_command = "rg",
						get_command_args = function(prefix, _)
							-- /usr/share/dict/words
							local dict_file1 = os.getenv("HOME") .. "/dotfiles/dictionaries/words"
							local dict_file2 = os.getenv("HOME") .. "/dotfiles/dot-config/nvim/spell/en.utf-8.add"
							return {
								"--color=never",
								"--no-line-number",
								"--no-messages",
								"--no-filename",
								"--ignore-case",
								"--",
								prefix,
								dict_file1,
								dict_file2,
							}
						end,
						documentation = {
							enable = true,
							get_command = {
								"wn", -- brew install wordnet
								"${word}",
								"-over",
							},
						},
					},
				},
			},
		},

		fuzzy = {
			implementation = "prefer_rust_with_warning",
		},

		signature = {
			enabled = true,
			trigger = {
				enabled = true,
				-- Show the signature help window after typing any of alphanumerics, `-` or `_`
				show_on_keyword = false,
				blocked_trigger_characters = {},
				blocked_retrigger_characters = {},
				-- Show the signature help window after typing a trigger character
				show_on_trigger_character = true,
				-- Show the signature help window when entering insert mode
				show_on_insert = true,
				-- Show the signature help window when the cursor comes after a trigger character when entering insert mode
				show_on_insert_on_trigger_character = true,
			},
		},
	},
	opts_extend = { "sources.default" },
}
