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

autocmd("VimEnter", {
  pattern = "*",
  command = "if argc() == 0 && !exists('s:std_in') | NvimTreeOpen | endif"
})
