---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<C-h>"] = {"<cmd> TmuxNavigateLeft<CR>", "window left"},
    ["<C-l>"] = {"<cmd> TmuxNavigateRight<CR>", "window right"},
    ["<C-j>"] = {"<cmd> TmuxNavigateDown<CR>", "window down"},
    ["<C-k>"] = {"<cmd> TmuxNavigateUp<CR>", "window up"},
    ["<C-s>"] = {"<cmd> w<CR>", "save file"}
  },
  i = {
    ["<C-s>"] = {"<cmd> w<CR>", "save file"}
  },
}


M.nvimtree = {
  n = {
    ["<F5>"] = {"<cmd> NvimTreeToggle <CR>", "Toggle nvimtree"},
    ["<F4>"] = {"<cmd> :bd <CR>", "Close current file"},
    ["<C-q>"] = {"<cmd> :q! <CR>", "Close session without saving"},
    ["<A-q>"] = {"<cmd> :cq <CR>", "Close session with error code"}, -- Useful to abort commit
    ["<leader><C-w>"] = {"<cmd> :set wrap!<CR>", "Toggle word wrap"},
    ["<leader><Left>"] = { "<cmd> :bp!<CR>", "Switch to previous buffer"},
    ["<leader><Right>"] = { "<cmd> :bn!<CR>", "Switch to previous buffer"},
  },
  v = {
    ["<F5>"] = {"<cmd> NvimTreeToggle <CR>", "Toggle nvimtree"},
  },
  i = {
    ["<F5>"] = {"<cmd> NvimTreeToggle <CR>", "Toggle nvimtree"},
  },
}
-- more keybinds!

return M

