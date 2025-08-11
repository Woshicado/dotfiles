return {
  "moll/vim-bbye",
  event = "VeryLazy",
  config = function()
    vim.g.bbye_no_prompt = true
    vim.g.bbye_no_mappings = true
    vim.keymap.set("n", "<leader>x", ":Bdelete<CR>", { desc = "Delete buffer" })
    vim.keymap.set("n", "<leader>X", ":Bdelete!<CR>", { desc = "Force delete buffer" })
  end,
}
