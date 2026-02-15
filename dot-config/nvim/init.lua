vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("lazy-config")

vim.g.python3_host_prog = os.getenv("HOME") .. "/.local/pipx/venvs/pynvim/bin/python"

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},

	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("nvchad.autocmds")
require("options")

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.mail = {
  install_info = {
    -- specific to local path installation:
    url = vim.fn.stdpath('config') .. "/custom/tree-sitter-mail",
    files = { "src/parser.c" }, -- REQUIRED: tell nvim where the source is
    -- optional entries:
    branch = "main",
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "mail", -- if filetype is 'mail', this associates it automatically
}

vim.api.nvim_set_hl(0, "Folded", { bg = "#2c2956", fg = "#888888" }) -- Folded text
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

vim.schedule(function()
	require("mappings")
end)
