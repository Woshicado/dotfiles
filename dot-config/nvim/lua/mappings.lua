-- require("nvchad.mappings")
require("complicated_mappings")

local del = vim.keymap.del
local map = vim.keymap.set

-- NvChad mappings, copied over to not have to use all of them
map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

if require("nvconfig").ui.tabufline.enabled then
  map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

  map("n", "<tab>", function()
    require("nvchad.tabufline").next()
  end, { desc = "buffer goto next" })

  map("n", "<S-tab>", function()
    require("nvchad.tabufline").prev()
  end, { desc = "buffer goto prev" })
end

map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

map({ "n", "t" }, "<M-i>", function()
  require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
end, { desc = "terminal toggle floating term" })

-- delete unwanted nvchad mappings first
-- Normal mode bindings to delete
local keys = {
	"<leader>w",
	"<leader>wa",
	"<leader>wl",
	"<leader>wr",
	"<leader>ws",
	"<leader>cm",
  -- "<leader>th",
  -- "<leader>h",
  -- "<leader>v",
}

for _, key in ipairs(keys) do
	pcall(del, "n", key)
end
pcall(del, "i", "jj")

map({ "i", "v", "n" }, "<Up>", "<Nop>")
map({ "i", "v", "n" }, "<Down>", "<Nop>")
map({ "i", "v", "n" }, "<Left>", "<Nop>")
map({ "i", "v", "n" }, "<Right>", "<Nop>")

map("n", "<leader>v", "^vg_", { desc = "Select non-whitespace line", noremap = true })

-- Save keybind
map("n", "<leader>w", "<cmd>w<cr>", { noremap = true, desc = "Save File" })

-- Exit keybinds
map("n", "<leader>qq", "<cmd>:q!<CR>", { desc = "Close window without saving", noremap = true })
map({ "n", "i", "v" }, "<M-q>", "<cmd> :qa! <CR>", { desc = "Close session without saving", noremap = true })

-- Misc Meta
map({ "n", "v" }, "<leader><C-w>", "<cmd> :set wrap!<CR>", { desc = "Toggle word wrap", noremap = true }) -- Toogle word wrap
map({ "n", "v" }, "<leader>lr", "<cmd> :set invrelativenumber<CR>", { desc = "Toggle absolute/relative surrounding line numbers.", noremap = true })

-- Buffer navigation
map({ "n", "v" }, "<leader><Left>", "<cmd>bp!<CR>", { desc = "Switch to previous buffer", noremap = true })
map({ "n", "v" }, "<leader><Right>", "<cmd>bn!<CR>", { desc = "Switch to next buffer", noremap = true })
map({ "n", "v" }, "<C-S-o>", "<C-i>", { desc = "Forward", noremap = true })

map("n", "<leader>sh", function() require("lsp_signature").toggle_float_win() end, { desc = "Toggle signature help", noremap = true })

map({ "n", "x" }, "<leader>sw", function()
	local ve = vim.o.virtualedit -- returns a string, e.g. "", "all", "block,onemore"
	if ve:find("all") then
		vim.opt.virtualedit = ""
		vim.notify("virtualedit disabled")
	else
		vim.opt.virtualedit = "all"
		vim.notify("virtualedit = all")
	end
end, { desc = "Toggle virtualedit=all" })

-- German umlauts
map({ "i", "t" }, "<M-o>", "ö", { desc = "ö" })
map({ "i", "t" }, "<M-u>", "ü", { desc = "ü" })
map({ "i", "t" }, "<M-a>", "ä", { desc = "ä" })
map({ "i", "t" }, "<M-S-o>", "Ö", { desc = "Ö" })
map({ "i", "t" }, "<M-S-u>", "Ü", { desc = "Ü" })
map({ "i", "t" }, "<M-S-a>", "Ä", { desc = "Ä" })


-- Terminal mappings
map("t", "<c-\\><ESC>", "<C-\\><C-n>", { noremap = true, desc = "Defocus terminal" })

-- Center screen on navigation with ctrl-u/d
map("n", "<C-u>", "<C-u>zz", { desc = "Center screen on navigation" })
map("n", "<C-d>", "<C-d>zz", { desc = "Center screen on navigation" })
map("n", "<C-f>", "<C-f>zz", { desc = "Center screen on navigation" })
map("n", "<C-b>", "<C-b>zz", { desc = "Center screen on navigation" })
-- Center screen on navigation with n/N
map("n", "n", "nzzzv", { desc = "Center screen on navigation with n" })
map("n", "N", "Nzzzv", { desc = "Center screen on navigation with N" })
-- Top screen on [[ and ]] and [m and ]m
map("n", "[[", "[[zt", { noremap = true, desc = "Top screen on [[" })
map("n", "]]", "]]zt", { noremap = true, desc = "Top screen on ]]" })
map("n", "[m", "[mzt", { noremap = true, desc = "Top screen [m" })
map("n", "]m", "]mzt", { noremap = true, desc = "Top screen ]m" })
-- Cetner screen on navigation with { and }
map("n", "{", "{zz", { desc = "Center screen on {" })
map("n", "}", "}zz", { desc = "Center screen on }" })

---- Text manipulation
-- Swap lines
map("n", "<A-Up>", ":m .-2<cr>==", { desc = "Move line up", noremap = true })
map("n", "<A-k>", ":m .-2<cr>==", { desc = "Move line up", noremap = true })
map("n", "<A-Down>", ":m .+1<cr>==", { desc = "Move line down", noremap = true })
map("n", "<A-j>", ":m .+1<cr>==", { desc = "Move line down", noremap = true })

map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move line up", noremap = true })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move line up", noremap = true })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move line down", noremap = true })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move line down", noremap = true })

map("i", "<A-Up>", "<Esc>:m .-2<cr>==gi", { desc = "Move line up", noremap = true })
map("i", "<A-k>", "<Esc>:m .-2<cr>==gi", { desc = "Move line up", noremap = true })
map("i", "<A-Down>", "<Esc>:m .+1<cr>==gi", { desc = "Move line down", noremap = true })
map("i", "<A-j>", "<Esc>:m .+1<cr>==gi", { desc = "Move line down", noremap = true })

-- Delete word
map("n", "<C-w>", [["_db]], { desc = "Delete word", noremap = true })

-- Toggle comment s
map("n", "<M-/>", "<leader>/==", { desc = "Toggle comment", remap = true })
map("v", "<M-/>", "<leader>/gv=gv", { desc = "Toggle comment", remap = true })
map("i", "<M-/>", "<C-o><leader>/", { desc = "Toggle comment", remap = true })

-- Code format
map("n", "<leader>cs", "<cmd>Shades<CR>", { desc = "Shadify", noremap = true })
map("n", "<leader>ch", "<cmd>Huefy<CR>", { desc = "Shadify", noremap = true })

-- Indentations
map("v", ">", ">gv", { desc = "Keep selection after indent", noremap = true })
map("v", "<", "<gv", { desc = "Keep selection after indent", noremap = true })

-- Paste/Delete/Substitute without yanking to clipboard
map("x", "p", [["_dP]])
map("x", "x", [["_x]])
map("x", "s", [["_s]])

-- Github copilot
map("i", "<C-c>", 'copilot#Accept("")', { expr = true, replace_keycodes = false })
map("i", "<C-f>", "<Plug>(copilot-accept-line)", { noremap = false })
-- map('i', '<C-g>', '<Plug>(copilot-suggest)', { noremap = false })
vim.g.copilot_no_tab_map = true

-- Smart home/end keys; Cmd for home and end
map("n", "<Home>", [[col('.') == matchend(getline('.'), '^\\s*')+1 ? '0' : '^']], { expr = true, noremap = true, desc = "Smart Home key" })
map("n", "<End>", [[col('.') == match(getline('.'), '\s*$') ? '$' : 'g_']], { expr = true, noremap = true, desc = "Smart End key" })
map("v", "<End>", [[col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_']], { expr = true, noremap = true, desc = "Smart End key in visual mode" })
map("i", "<Home>", "<C-o><Home>", { noremap = true, desc = "Home key in insert mode" })
map("i", "<End>", "<C-o><End>", { noremap = true, desc = "End key in insert mode" })

-- Step commands; To be able to repeat them with a simple <M-r> click we need a helper function and variable.

-- quickfix keybinds
-- Preferably use the default [q, ]q mappings etc.
map("n", "<leader>qc", ":copen<CR>", { noremap = true, silent = true })
map("n", "<leader>ql", ":lopen<CR>", { noremap = true, silent = true })
map("n", "<leader>qp", ":colder<CR>", { noremap = true, silent = true })
map("n", "<leader>qn", ":cnewer<CR>", { noremap = true, silent = true })
-- map("n", "<leader>qq", ":cclose<CR>", { noremap = true, silent = true })
map("n", "<leader>q[", ":cprev<CR>", { noremap = true, silent = true })
map("n", "<leader>q]", ":cnext<CR>", { noremap = true, silent = true })
map("n", "<leader>qP", ":cpf<CR>", { noremap = true, silent = true })
map("n", "<leader>qN", ":cnf<CR>", { noremap = true, silent = true })
map("n", "<leader>q{", ":colder<CR>", { noremap = true, silent = true })
map("n", "<leader>q}", ":cnewer<CR>", { noremap = true, silent = true })
map("n", "[<S-q>", ":colder<CR>", { noremap = true, silent = true })
map("n", "]<S-q>", ":cnewer<CR>", { noremap = true, silent = true })

-- Toggle transparency on <leader>to
map("n", "<leader>to", function() require("base46").toggle_transparency() end, { desc = "Toggle transparency" })


-- Obsidian keybinds
map("n", "<leader>oo", ":cd $O_VAULT_DIR<CR>", { desc = "Open Obsidian notes" })
map("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>", { desc = "Strip date from title" })
map("n", "<leader>ok", ":!mv '%:p' $O_VAULT_DIR/zettelkasten<cr>:bd<cr>", { desc = "Move file to zettelkasten" })
map("n", "<leader>or", ":!rm '%:p'<cr>:bd<cr>", { desc = "Remove file" })

-- Yank buffer path/name/dir to clipboard
map("n", "<leader>yp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end, { desc = "Yank abs path (buffer)" })
map("n", "<leader>yP", function() vim.fn.setreg("+", vim.fn.expand("%")) end, { desc = "Yank rel path (buffer)" })
map("n", "<leader>yd", function() vim.fn.setreg("+", vim.fn.expand("%:p:h")) end, { desc = "Yank abs path (directory)" })
map("n", "<leader>yn", function() vim.fn.setreg("+", vim.fn.expand("%:t")) end, { desc = "Yank filename (buffer)" })

-- open definition in split view
local bufopts = { noremap = true, silent = true }
map("n", "<leader>gv", function() vim.cmd("vsplit") vim.lsp.buf.definition() end, bufopts)
map("n", "<leader>gh", function() vim.cmd("split") vim.lsp.buf.definition() end, bufopts)

map("n", "gp", "`[v`]", { desc = "Visual pasted" })
map("n", "gP", "`]v`[", { desc = "Visual pasted" })

-- Paste from number registers conveniently
for i = 0, 9 do
  vim.keymap.set('n', '<leader>' .. i, '"' .. i .. 'p', { desc = 'Paste from register ' .. i })
  -- yank into number registers; not sure whether that helpful yet since nvim cycles through them automatically...
  vim.keymap.set('n', '<leader>y' .. i, '"' .. i .. 'y', { desc = 'Yank into register ' .. i })
  vim.keymap.set('v', '<leader>y' .. i, '"' .. i .. 'y', { desc = 'Yank into register ' .. i })
end
vim.keymap.set('n', '<leader>-', '"-p', { desc = 'Paste from small delete register' })

-- Move lines
map('v', '<C-k>', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
map('v', '<C-j>', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- treesitter incremental selection
vim.keymap.set("n", "<CR>", function()
  -- Only hijack CR when not in quickfix
  if vim.bo.buftype == "" then
    vim.cmd("normal van")
  else
    vim.cmd("normal! \r")
  end
end)
vim.keymap.set("v", "<CR>", "an", { desc = "Expand selection to parent node", remap = true })
vim.keymap.set("v", "<BS>", "in", { desc = "Shrink selection to child node", remap = true })
