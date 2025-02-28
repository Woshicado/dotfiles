require "nvchad.options"

-- add yours here!

local o = vim.opt

o.ruler = true
o.cursorlineopt = "both"
o.scrolloff = 8
o.cc = { 80, 100 }
o.linebreak = true
o.breakindent = true
o.showbreak = "=>"
o.conceallevel = 2
o.spellfile = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"
o.relativenumber = true
o.foldmethod = "syntax"
o.foldenable = false
o.tabstop = 2
o.shiftwidth = 0
o.softtabstop = -1
o.smarttab = true
o.expandtab = true
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
