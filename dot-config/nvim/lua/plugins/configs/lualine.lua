-- Attached LSP clients, as an icon plus a count
local function lsp_status()
	local n = #vim.lsp.get_clients({ bufnr = 0 })
	if n == 0 then
		return ""
	end
	return n > 1 and ("  " .. n) or " "
end

-- Only renders when this Neovim is running over SSH.
local function ssh_session()
	if not (vim.env.SSH_TTY or vim.env.SSH_CONNECTION) then
		return ""
	end
	return "  " .. vim.fn.hostname()
end

local opts = {
	options = {
		theme = "kanagawa",
		globalstatus = true, -- we run laststatus=3
		icons_enabled = true,
		section_separators = { left = "", right = "" },
		component_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = { "oil", "neo-tree", "dashboard" },
		},
	},

	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				path = 1,
				shorting_target = 40,
				symbols = {
					modified = "●",
					readonly = "󰏯 ",
					unnamed = " [No Name]",
					newfile = " ",
				},
			},
		},
		lualine_x = { { ssh_session }, { lsp_status }, "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},

	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
}

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	config = function()
		local lualine = require("lualine")
		lualine.setup(opts)

		--[[ kanagawa's lualine theme snapshots the palette at require-time, so toggling
		     'background' leaves it stale. Drop the cached module and re-apply. ]]
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("LualineKanagawa", { clear = true }),
			callback = function()
				package.loaded["lualine.themes.kanagawa"] = nil
				lualine.setup(opts)
			end,
		})
	end,
}
