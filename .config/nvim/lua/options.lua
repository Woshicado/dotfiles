require "nvchad.options"

-- add yours here!

local o = vim.opt

o.encoding = "utf-8"
o.ruler = true
o.cursorlineopt = "both"
o.scrolloff = 8
o.sidescroll = 8
o.cc = { 80, 100 }
o.linebreak = true
o.breakindent = true
o.showbreak = "=>"
o.conceallevel = 2
o.spellfile = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"
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
o.foldenable = false
o.foldlevel = 99
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- or v:lua.vim.treesitter.foldexpr()
o.foldtext = ""
o.foldcolumn = "0"
o.fillchars:append { fold = " " }

-- I don't know if these do anything, or what exactly they are supposed to do
o.diffopt = {
    "internal",
    "filler",
    "closeoff",
    "context:12",
    "algorithm:histogram",
    "linematch:200",
    "indent-heuristic",
    "iwhite" -- I toggle this one, it doesn't fit all cases.
}
