require "nvchad.mappings"
require "complicated_mappings"

-- add yours here

local map = vim.keymap.set

-- map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Save keybinds
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>") -- Save on Ctrl-S
map({ "n", "i", "v" }, "<M-s>", "<cmd> w <cr>") -- Save on Cmd-S


-- Exit keybinds
map({ "n", "i", "v"}, "<C-q>", "<cmd> :q! <CR>", { desc = "Close session without saving", noremap=true })
map({ "n", "i", "v"}, "<A-q>", "<cmd> :qa! <CR>", { desc = "Close session without saving", noremap=true })

-- Misc Meta
-- map({ "n", "i", "v"}, "<C-a>", "ggVG", { desc = "Select all", noremap=true }) -- Select all in current file
map({ "n", "v"}, "<leader><C-w>", "<cmd> :set wrap!<CR>", { desc = "Toggle word wrap", noremap=true }) -- Toogle word wrap
map({ "n", "i", "v"}, "<M-e>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree", noremap=true })
map({ "n", "v" }, "<leader>lr", "<cmd> :set invrelativenumber<CR>", {desc = "Toggle absolute/relative surrounding line numbers.", noremap=true})


-- Buffer navigation
map({ "n", "v"}, "<leader><Left>",  "<cmd> :bp!<CR>", { desc = "Switch to previous buffer", noremap=true })
map({ "n", "v"}, "<leader><Right>", "<cmd> :bn!<CR>", { desc = "Switch to next buffer", noremap=true })
map({ "n", "v"}, "<M-x>",           "<cmd> :bd <CR>", { desc = "Close current file", noremap=true })
map({ "n", "v"}, "<C-S-o>",         "<C-i>",          { desc = "Forward", noremap=true })

-- Tmux integration
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left", noremap=true })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right", noremap=true })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down", noremap=true })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up", noremap=true })


-- Oil go to parent directory
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })


-- This seems useless since I get fuzzy suggestions anyway, but w/e
vim.keymap.set({ "i" }, "<C-x><C-f>",
  function()
    require("fzf-lua").complete_file({
      cmd = "rg --files",
      winopts = { preview = { hidden = true } }
    })
  end, { silent = true, desc = "Fuzzy complete file" })


-- replace telescope with fzf
map("n", "<leader>ff", function() require("fzf-lua").files() end, { noremap = true, desc = "Fuzzy find files" })-- stylua: ignore
map("n", "<leader>fa", function() require("fzf-lua").git_files() end, { noremap = true, desc = "Fuzzy find git files" })
map("n", "<leader>fb", function() require("fzf-lua").buffers() end, { noremap = true, desc = "Fuzzy find buffers" })
map("n", "<leader>fo", function() require("fzf-lua").oldfiles() end, { noremap = true, desc = "Fuzzy find recent files" })
map("n", "<leader>fr", function() require("fzf-lua").oldfiles() end, { noremap = true, desc = "Fuzzy find recent files" })
map("n", "<leader>fw", function() require("fzf-lua").grep_cword() end, { noremap = true, desc = "Fuzzy find word in project" })
map("n", "<leader>fl", function() require("fzf-lua").live_grep() end, { noremap = true, desc = "Fuzzy live grep in project" })
map("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { noremap = true, desc = "Fuzzy live grep in project" })
map("n", "<leader>fz", function() require("fzf-lua").lgrep_curbuf() end, { noremap = true, desc = "Fuzzy live current buffer" })


-- Telescope git pickers
map("n", "<leader>gs", function() require("fzf-lua").git_stash() end, { noremap = true, desc = "Telescope git stashes" })
map("n", "<leader>gc", function() require("fzf-lua").git_commits() end, { noremap = true, desc = "Telescope git commits" })
map("n", "<leader>gb", function() require("fzf-lua").git_branches() end, { noremap = true, desc = "Telescope git branches" })
map("n", "<leader>gg", function() require("neogit").open() end, { noremap = true, desc = "Open git changes" })


-- delete unused mappings
local nomap = vim.keymap.del
nomap("n", "<leader>cm")
nomap("n", "<leader>th")


-- Session management
map("n", "<leader>wr", "<cmd>SessionSearch<CR>", { noremap = true, desc = "Session search" })
map("n", "<leader>ws", "<cmd>SessionSave<CR>", { noremap = true, desc = "Save session" })
-- map("n", "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", { noremap = true, desc = "Toggle autosave" })


-- Terminal mappings
map('t', '<c-\\><ESC>', '<C-\\><C-n>', { noremap = true, desc = "Defocus terminal" })

-- Center screen on navigation with ctrl-u/d
map("n", "<C-u>", "<C-u>zz", { desc = "Center screen on navigation" })
map("n", "<C-d>", "<C-d>zz", { desc = "Center screen on navigation" })
-- Center screen on navigation with n/N
map("n", "n", "nzzzv", { desc = "Center screen on navigation with n"})
map("n", "N", "Nzzzv", { desc = "Center screen on navigation with N"})
-- Top screen on [[ and ]] and [m and ]m
map("n", "[[", "[[zt", { noremap = true,  desc = "Top screen on [["})
map("n", "]]", "]]zt", { noremap = true,  desc = "Top screen on ]]"})
map("n", "[m", "[mzt", { noremap = true,  desc = "Top screen [m"})
map("n", "]m", "]mzt", { noremap = true,  desc = "Top screen ]m"})
-- Cetner screen on navigation with { and }
map("n", "{", "{zz", { desc = "Center screen on {"})
map("n", "}", "}zz", { desc = "Center screen on }"})


---- Text manipulation

-- Swap lines
map("n", "<A-Up>",   ":m .-2<cr>==", { desc = "Move line up", noremap=true })
map("n", "<A-k>",    ":m .-2<cr>==", { desc = "Move line up", noremap=true })
map("n", "<A-Down>", ":m .+1<cr>==", { desc = "Move line down", noremap=true })
map("n", "<A-j>",    ":m .+1<cr>==", { desc = "Move line down", noremap=true })

map("v", "<A-Up>",   ":m '<-2<cr>gv=gv", { desc = "Move line up", noremap=true })
map("v", "<A-k>",    ":m '<-2<cr>gv=gv", { desc = "Move line up", noremap=true })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move line down", noremap=true })
map("v", "<A-j>",    ":m '>+1<cr>gv=gv", { desc = "Move line down", noremap=true })

map("i", "<A-Up>",   "<Esc>:m .-2<cr>==gi", { desc = "Move line up", noremap=true })
map("i", "<A-k>",    "<Esc>:m .-2<cr>==gi", { desc = "Move line up", noremap=true })
map("i", "<A-Down>", "<Esc>:m .+1<cr>==gi", { desc = "Move line down", noremap=true })
map("i", "<A-j>",    "<Esc>:m .+1<cr>==gi", { desc = "Move line down", noremap=true })

-- Delete word
map("n", "<C-w>", [["_db]], { desc = "Delete word", noremap=true })

-- Toggle comment s
map("n", "<M-/>", "<leader>/==", { desc = "Toggle comment", remap=true })
map("v", "<M-/>", "<leader>/gv=gv", { desc = "Toggle comment", remap=true })
map("i", "<M-/>", "<C-o><leader>/",   { desc = "Toggle comment", remap=true })

-- Code format
map({ "n", "v" }, "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format code", noremap=true })

-- Indentations
map("v", ">",       ">gv",   { desc = "Keep selection after indent", noremap=true })
map("v", "<",       "<gv",   { desc = "Keep selection after indent", noremap=true })
map("v", "<Tab>",   ">gv",   { desc = "Indent using tab in visual mode", noremap=true })
map("v", "<S-Tab>", "<gv",   { desc = "Indent using tab in visual mode", noremap=true })
map("i", "<S-Tab>", "<C-d>", { desc = "Unindent in insert mode", noremap=true })

-- Paste without yanking to clipboard
map("x", "p", [["_dP]])

-- Github copilot
map('i', '<C-c>', 'copilot#Accept("")', { expr = true, replace_keycodes = false })
map('i', '<C-f>', '<Plug>(copilot-accept-line)', { noremap = false })
map('i', '<C-g>', '<Plug>(copilot-suggest)', { noremap = false })
vim.g.copilot_no_tab_map = true

-- Smart home/end keys; Cmd for home and end
map("n", "<Home>", [[col('.') == matchend(getline('.'), '^\\s*')+1 ? '0' : '^']], { expr = true, noremap = true, desc = "Smart Home key" })
map("n", "<End>",  [[col('.') == match(getline('.'), '\s*$') ? '$' : 'g_']], { expr = true, noremap = true, desc = "Smart End key" })
map("v", "<End>",  [[col('.') == match(getline('.'), '\s*$') ? '$h' : 'g_']], { expr = true, noremap = true, desc = "Smart End key in visual mode" })
map("i", "<Home>", "<C-o><Home>", { noremap = true, desc = "Home key in insert mode" })
map("i", "<End>",  "<C-o><End>", { noremap = true, desc = "End key in insert mode" })


-- Debugging keybinds with dap and `<leader>d.`
map("n", "<leader>db", function() require('dap').toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function() require('dap').continue() end, { desc = "Continue" })
map("n", "<leader>dl", function() require('dap').run_last() end, { desc = "Run last" })


map({ "n", "v" }, "<leader>de", function() require('dapui').eval() end, { desc = "Eval expression" })
map("n", "<leader>dt", function() require("dapui").toggle() end, { desc = "DapUI close" })
map("n", "<leader>dp", function() require('dap').toggle_breakpoint(vim.fn.input('Condition: '), nil, nil ) end, { desc = "Toggle _conditional_ breakpoint" })


-- VSCode mappings
map('n', '<F5>', function() require('dap').continue() end)
map('n', '<F10>', function() require('dap').step_over() end)
map('n', '<F11>', function() require('dap').step_into() end)
map('n', '<F12>', function() require('dap').step_out() end)


map({'n', 'v'}, '<Leader>dh', function() require('dap.ui.widgets').hover() end)
map('n', '<Leader>dw', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)


-- Send selection to repl
map("n", "<leader>dr", function() require('dap').repl.toggle() end, { desc = "Toggle repl" })
-- map("v", "<leader>ds", function() require('dap').repl.run() end, { desc = "Send selection to repl" })

-- Step commands; To be able to repeat them with a simple <M-r> click we need a helper function and variable.
local last_dap_step = nil
local function repeat_last_step()
  if last_dap_step then
    last_dap_step()
  else
    print "No previous step action"
  end
end

local function set_last_step(fn)
  last_dap_step = fn
  fn()
end

map("n", "<leader>dn", function() set_last_step(require('dap').step_over) end, { desc = "Step Over", noremap = true, silent = true })
map("n", "<leader>di", function() set_last_step(require('dap').step_into) end, { desc = "Step Into", noremap = true, silent = true })
map("n", "<leader>do", function() set_last_step(require('dap').step_out) end, { desc = "Step Out", noremap = true, silent = true })
map("n", '<leader>du', function() set_last_step(require("dap").up) end, { desc = "Step Out", noremap = true, silent = true })
map("n", '<leader>dd', function() set_last_step(require("dap").down) end, { desc = "Step Out", noremap = true, silent = true })
map("n", "<M-r>",      function() repeat_last_step() end, { desc = "Repeat Last Step", noremap = true, silent = true })

-- quickfix keybinds
map("n", "<leader>qc", ":copen<CR>", { noremap = true, silent = true }) -- Open Quickfix
map("n", "<leader>ql", ":lopen<CR>", { noremap = true, silent = true }) -- Open Location List
map("n", "<leader>qo", ":colder<CR>", { noremap = true, silent = true }) -- Older Quickfix List
map("n", "<leader>qn", ":cnewer<CR>", { noremap = true, silent = true }) -- Newer Quickfix List


-- timber logs
map("n", "glt", function()
  require("timber.actions").insert_log({
    templates = { before = "time_start", after = "time_end" },
    position = "surround",
  })
end, {
  desc = "[G]o [L]og [T]ime",
})

map("n", "glh", function()
  require("timber.actions").insert_log({
    template = "file",
    position = "below",
  })
end, {
  desc = "[G]o [L]og [H]ere: With location",
})
map("n", "glc", function()
  require("timber.actions").clear_log_statements({ global = false })
end, {
  desc = "[G]o [L]og [C]lean",
})
map("n", "glp", function()
require("timber.actions").insert_log({
    template = "pretty",
    position = "below",
  })
end, {
  desc = "[G]o [L]og [P]retty print",
})

-- Toggle theme on <leader>tt
map("n", "<leader>tt", function()
  require("base46").toggle_theme()
end, {
  desc = "Toggle theme",
})
-- Toggle transparency on <leader>to
map("n", "<leader>to", function()
  require('base46').toggle_transparency()
end, {
  desc = "Toggle transparency",
})


-- Obsidian keybinds
map("n", "<leader>oo", ":cd $O_VAULT_DIR<CR>", { desc = "Open Obsidian notes" })
map("n", "<leader>on", ":ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", { desc = "Insert obsidian default note template" })
map("n", "<leader>od", ":ObsidianToday<cr>", { desc = "Open today's daily note" })
map("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>", { desc = "Strip date from title" })
map("n", "<leader>os", function () require("fzf-lua").files({ cwd = "$O_VAULT_DIR" }) end, { desc = "find file in obsidian notes"})
map("n", "<leader>oz", function () require("fzf-lua").live_grep({ cwd = "$O_VAULT_DIR" }) end, { desc = "grep in obsidian notes"})
map("n", "<leader>ok", ":!mv '%:p' $O_VAULT_DIR/zettelkasten<cr>:bd<cr>", { desc = "Move file to zettelkasten" })
map("n", "<leader>or", ":!rm '%:p'<cr>:bd<cr>", { desc = "Remove file" })
