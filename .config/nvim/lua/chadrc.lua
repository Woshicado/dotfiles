-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "penumbra_light",

  hl_override = {
    Comment = { italic = true, bold = true },
    ["@comment"] = { italic = true, bold = true },
    String = { italic = true },
    ["@string"] = { italic = true },
  },
  theme_toggle = {
    "onedark",
    "penumbra_light",
  },
}

require "configs.neogithl"

local autocmd = vim.api.nvim_create_autocmd
local usercmd = vim.api.nvim_create_user_command

-- Expose a command for formatting
usercmd("Format", function()
  require("conform").format()
end, {})

-- auto delete trailing whitespace
autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- Set the correct fold method if treesitter is available for the given filetype
autocmd({ "FileType" }, {
  callback = function()
    if require("nvim-treesitter.parsers").has_parser() then
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    else
      vim.opt.foldmethod = "syntax"
    end
  end,
})

--[[ I decided against using this because it will destroy collaborating.
     On top of that, there are config diffs between formatters and lsp's/linters. ]]
-- Overwrite tab behavior to my preferences... This might break formatting for shared workspaces
-- autocmd({ "FileType" }, {
--   pattern = 'python', -- change this
--   callback = function()
--     vim.opt.tabstop = 2
--     vim.opt.softtabstop = 2
--     vim.opt.shiftwidth = 2
-- 		 vim.opt.expandtab = false
--   end,
-- })

return M
