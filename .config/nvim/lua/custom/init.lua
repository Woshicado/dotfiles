local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--

vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.scrolloff = 8
vim.opt.cc = {80,100}
vim.opt.smarttab = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "=>"
vim.opt.conceallevel = 2

autocmd("VimEnter", {
  pattern = "*",
  command = "if argc() == 0 && !exists('s:std_in') | NvimTreeOpen | endif"
})

autocmd("ExitPre", {
	group = vim.api.nvim_create_augroup("Exit", { clear = true }),
	command = "set guicursor=a:hor50",
	desc = "Set cursor back to underline when leaving Neovim."
})
