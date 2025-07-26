return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"andrew-george/telescope-themes",
		"nvim-lua/plenary.nvim",
		"debugloop/telescope-undo.nvim",
	},
	keys = {
		{ -- lazy style key map
			"<leader>u",
			"<cmd>Telescope undo<cr>",
			desc = "undo history",
		},
	},
	opts = {
		extensions_list = { "themes", "fzf" },
		extensions = {
			undo = {
				use_delta = true,
				side_by_side = true,
				layout_strategy = "vertical",
				layout_config = {
					preview_height = 0.8,
					prompt_position = "top",
				},
				vim_diff_opts = {
					ctxlen = 16,
				},
			},
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			["ui-select"] = {
				require("telescope.themes").get_dropdown({}),
			},
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.load_extension("themes")
		telescope.setup(opts)
		telescope.load_extension("undo")
	end,
}

