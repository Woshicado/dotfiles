local map = vim.keymap.set

-- Normal Mode
map("n", ";", ":", { nowait = true, desc = "enter command mode", noremap=true })
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left", noremap=true })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right", noremap=true })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down", noremap=true })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up", noremap=true })
map("n", "<C-s>", "<cmd> w<CR>", { desc = "save file", noremap=true })
map("n", "<F5>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree", noremap=true })
map("n", "<F4>", "<cmd> :bd <CR>", { desc = "Close current file", noremap=true })
map("n", "<C-q>", "<cmd> :q! <CR>", { desc = "Close session without saving", noremap=true })
map("n", "<A-q>", "<cmd> :cq <CR>", { desc = "Close session with error code", noremap=true })
map("n", "<leader><C-w>", "<cmd> :set wrap!<CR>", { desc = "Toggle word wrap", noremap=true })
map("n", "<leader><Left>", "<cmd> :bp!<CR>", { desc = "Switch to previous buffer", noremap=true })
map("n", "<leader><Right>", "<cmd> :bn!<CR>", { desc = "Switch to next buffer", noremap=true })
map("n", "<C-a>", "ggVG", { desc = "Select all", noremap=true })
map("n", "<A-k>", "ddkP", { desc = "Swap current line with the previous line", noremap=true })
map("n", "<A-j>", "ddp", { desc = "Swap current line with the next line", noremap=true })
map("n", "<A-Up>", "ddkP", { desc = "Swap current line with the previous line", noremap=true })
map("n", "<A-Down>", "ddp", { desc = "Swap current line with the next line", noremap=true })

map("n", "<leader>ln", "<cmd> :set invnumber<CR>", {desc = "Toggle absolute/relative current line number", noremap=true})
map("n", "<leader>lr", "<cmd> :set invrelativenumber<CR>", {desc = "Toggle absolute/relative surrounding line numbers.", noremap=true})
map("n", "<Leader>/", ":CommentToggle<CR>", { desc = "Toggle comment", noremap=true })
map("n", "<A-Left>", "b", { desc = "Move one word backward", noremap=true })  -- Move backward in insert mode
map("n", "<A-Right>", "w", { desc = "Move one word forward", noremap=true })  -- Move forward in insert mode
map("n", "<A-h>", "b", { desc = "Move one word backward", noremap=true })  -- Move backward in insert mode
map("n", "<A-l>", "w", { desc = "Move one word forward", noremap=true })  -- Move forward in insert mode



-- Visual mode mappings
map("v", "<F5>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree", noremap=true })
map("v", "<C-a>", "<Esc>ggVG", { desc = "Select all in visual mode", noremap=true })
map("v", "<C-s>", "<cmd> w<CR>", { desc = "save file", noremap=true })
map("v", "<C-q>", "<cmd> :q! <CR>", { desc = "Close session without saving", noremap=true })
map("v", "<A-q>", "<cmd> :cq <CR>", { desc = "Close session with error code", noremap=true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up", noremap=true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down", noremap=true })
map("v", "<Leader>/", ":CommentToggle<CR>", { desc = "Toggle comment in visual mode", noremap=true })

-- Insert mode mappings
map("i", "<F6>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree", noremap=true })
map("i", "<C-s>", "<cmd> w<CR>",    { desc = "save file", noremap=true })
map("i", "<C-q>", "<cmd> :q! <CR>", { desc = "Close session without saving", noremap=true })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all in insert mode", noremap=true })
map("i", "<A-q>", "<cmd> :cq <CR>", { desc = "Close session with error code", noremap=true })
map("i", "<A-k>", "<Esc>ddkP<Esc>i", { desc = "Swap current line with the previous line", noremap=true })
map("i", "<A-j>", "<Esc>ddp<Esc>i", { desc = "Swap current line with the next line", noremap=true })
map("i", "<A-Up>", "<Esc>ddkP<Esc>i", { desc = "Swap current line with the previous line", noremap=true })
map("i", "<A-Down>", "<Esc>ddp<Esc>i", { desc = "Swap current line with the next line", noremap=true })
map("i", "<C-h>", "<C-w>", { desc = "Ctrl+Backspace to delete word", noremap=true })


map("i", "<A-Left>", "<C-o>b", { desc = "Move one word backward", noremap=true })  -- Move backward in insert mode
map("i", "<A-Right>", "<C-o>w", { desc = "Move one word forward", noremap=true })  -- Move forward in insert mode
map("i", "<A-h>", "<C-o>b", { desc = "Move one word backward", noremap=true })  -- Move backward in insert mode
map("i", "<A-l>", "<C-o>w", { desc = "Move one word forward", noremap=true })  -- Move forward in insert mode

