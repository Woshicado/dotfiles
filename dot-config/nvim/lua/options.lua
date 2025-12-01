require("nvchad.options")

local o = vim.opt
local g = vim.g

g.editorconfig = true

-- NvChad

o.laststatus = 3
o.showmode = false
o.splitkeep = "screen"
o.clipboard = "unnamedplus"
o.cursorlineopt = "number"
o.mouse = "a"
o.number = true
o.numberwidth = 2
o.shortmess:append("sI")
o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true
o.updatetime = 250
o.whichwrap:append("<>[]hl")
g.loaded_node_provider = 0
-- g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- custom
o.encoding = "utf-8"
o.ruler = true
o.cursorlineopt = "both"
o.scrolloff = 10
o.sidescroll = 8
o.cc = { 80, 100 }
o.linebreak = true
o.breakindent = true
o.showbreak = "=>"
o.conceallevel = 0
o.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
o.relativenumber = true
o.autoindent = true
o.list = true
o.listchars = { tab = "» ", trail = "·", extends = "›", precedes = "‹", nbsp = "·" }
o.ignorecase = true
o.smartcase = true
o.tabstop = 2
o.shiftwidth = 0
o.softtabstop = -1
o.smarttab = true
o.expandtab = true
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
o.foldenable = true
o.smartindent = false
o.foldlevel = 99
o.foldlevelstart = 99
o.foldmethod = "manual"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- or v:lua.vim.treesitter.foldexpr()
o.foldtext = ""
o.foldcolumn = "0"
o.fillchars:append({ fold = " " })
o.winborder = "rounded"

o.swapfile = false

o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- I don't know if these do anything, or what exactly they are supposed to do
o.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"context:12",
	"algorithm:histogram",
	"linematch:200",
	"indent-heuristic",
	"iwhite", -- I toggle this one, it doesn't fit all cases.
}

require("highlight")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "tex",
	callback = function()
		-- Use vim.bo (buffer options) or vim.b (buffer vars) is fine, but must be string key
		vim.b["surround_" .. string.byte("e")] = [[\begin{\1environment: \1}\n\t\r\n\end{\1\1}]]
		vim.b["surround_" .. string.byte("c")] = [[\\\1command: \1{\r}]]
	end,
})
