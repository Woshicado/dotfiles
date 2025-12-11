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

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
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

map({ "n", "t" }, "<A-i>", function()
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

-- map("i", "jk", "<ESC>")  -- Already mapped, I guess by nvchad

-- Save keybinds
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>", { noremap = true, desc = "Save File" }) -- Save on Ctrl-S
map({ "n", "i", "v" }, "<M-s>", "<cmd> w <cr>", { noremap = true, desc = "Save File" }) -- Save on Cmd-S
map("n", "<leader>w", "<cmd>w<cr>", { noremap = true, desc = "Save File" })

-- Exit keybinds
-- map({ "n", "i", "v"}, "<C-q>", "<cmd>:q!<CR>", { desc = "Close window without saving", noremap=true })
map("n", "<leader>qq", "<cmd>:q!<CR>", { desc = "Close window without saving", noremap = true })
map({ "n", "i", "v" }, "<M-q>", "<cmd> :qa! <CR>", { desc = "Close session without saving", noremap = true })

-- Misc Meta
map({ "n", "v" }, "<leader><C-w>", "<cmd> :set wrap!<CR>", { desc = "Toggle word wrap", noremap = true }) -- Toogle word wrap
map({ "n", "i", "v" }, "<M-e>", "<cmd> NvimTreeToggle <CR>", { desc = "Toggle nvimtree", noremap = true })
map({ "n", "v" }, "<leader>lr", "<cmd> :set invrelativenumber<CR>", { desc = "Toggle absolute/relative surrounding line numbers.", noremap = true })

-- Buffer navigation
map({ "n", "v" }, "<leader><Left>", "<cmd>bp!<CR>", { desc = "Switch to previous buffer", noremap = true })
map({ "n", "v" }, "<leader><Right>", "<cmd>bn!<CR>", { desc = "Switch to next buffer", noremap = true })
-- map({ "n", "v"}, "<M-x>",           "<cmd>bwipeout<CR>", { desc = "Close current file", noremap=true })
-- map({ "n", "v"}, "<leader>x",       "<cmd>bwipeout<CR>", { desc = "Close current file", noremap=true })
map({ "n", "v" }, "<C-S-o>", "<C-i>", { desc = "Forward", noremap = true })

-- Tmux integration
map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "window left", noremap = true })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "window right", noremap = true })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "window down", noremap = true })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "window up", noremap = true })
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
-- map({"i", "t"}, "<M-o>", "<C-S-k>o:", { desc = "ö" })
-- map({"i", "t"}, "<M-u>", "<C-S-k>u:", { desc = "ü" })
-- map({"i", "t"}, "<M-a>", "<C-S-k>a:", { desc = "ä" })
-- map({"i", "t"}, "<M-S-o>", "<C-S-k>O:", { desc = "ö" })
-- map({"i", "t"}, "<M-S-u>", "<C-S-k>U:", { desc = "ü" })
-- map({"i", "t"}, "<M-S-a>", "<C-S-k>A:", { desc = "ä" })

map({ "i", "t" }, "<M-o>", "ö", { desc = "ö" })
map({ "i", "t" }, "<M-u>", "ü", { desc = "ü" })
map({ "i", "t" }, "<M-a>", "ä", { desc = "ä" })
map({ "i", "t" }, "<M-S-o>", "Ö", { desc = "Ö" })
map({ "i", "t" }, "<M-S-u>", "Ü", { desc = "Ü" })
map({ "i", "t" }, "<M-S-a>", "Ä", { desc = "Ä" })

-- Oil go to parent directory
map("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- yanky.nvim
map({ "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<c-n>", "<Plug>(YankyNextEntry)")
map("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
map("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
map("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
map("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

-- This seems useless since I get fuzzy suggestions anyway, but w/e
map({ "i" }, "<C-x><C-f>", function()
	vim.cmd('FzfLua complete_file cmd="rg --files" winopts="{ preview = { hidden = true } }"')
end, { silent = true, desc = "Fuzzy complete file" })

-- replace telescope with fzf
map("n", "<leader>ff", "<cmd>FzfLua files<CR>", { noremap = true, desc = "Fuzzy find files" })
map("n", "<leader>fa", "<cmd>FzfLua git_files<CR>", { noremap = true, desc = "Fuzzy find git files" })
map("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { noremap = true, desc = "Fuzzy find buffers" })
map("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", { noremap = true, desc = "Fuzzy find recent files" })
map("n", "<leader>fr", "<cmd>FzfLua resume<CR>", { noremap = true, desc = "Fuzzy find recent files" })
map("n", "<leader>fw", "<cmd>FzfLua grep_cword<CR>", { noremap = true, desc = "Fuzzy find word in project" })
map("n", "<leader>fc", "<cmd>FzfLua grep_cWORD<CR>", { noremap = true, desc = "Fuzzy find files" })
map("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { noremap = true, desc = "Fuzzy live grep in project" })
map("n", "<leader>fz", "<cmd>FzfLua lgrep_curbuf<CR>", { noremap = true, desc = "Fuzzy live current buffer" })
map("n", "<leader>fm", "<cmd>FzfLua marks<CR>", { noremap = true, desc = "Fuzzy marks" })
map("n", "<leader>fp", "<cmd>FzfLua paths<CR>", { noremap = true, desc = "Fuzzy complete path" })
map("n", "<leader>fq", "<cmd>FzfLua grep_quickfix<CR>", { noremap = true, desc = "Fuzzy quickfix list" })
map("n", "<leader>fl", "<cmd>FzfLua lgrep_loclist<CR>", { noremap = true, desc = "Fuzzy location list" })

-- Telescope git pickers
map({ "n", "x" }, "<leader>gs", "<cmd>FzfLua git_stash<CR>", { noremap = true, desc = "Fuzzy git stashes" })
map({ "n", "x" }, "<leader>gt", "<cmd>FzfLua git_status<CR>", { noremap = true, desc = "Fuzzy git status" })
map({ "n", "x" }, "<leader>gc", "<cmd>FzfLua git_bcommits<CR>", { noremap = true, desc = "Fuzzy git buffer commits" })
map({ "n", "x" }, "<leader>ga", "<cmd>FzfLua git_commits<CR>", { noremap = true, desc = "Fuzzy git commits" })
map({ "n", "x" }, "<leader>gb", "<cmd>FzfLua git_branches<CR>", { noremap = true, desc = "Fuzzy git branches" })
map({ "n", "x" }, "<leader>gl", "<cmd>FzfLua git_blame<CR>", { noremap = true, desc = "Fuzzy git blame" })
map({ "n", "x" }, "<leader>gg", function() require("neogit").open() end, { noremap = true, desc = "Open git changes" })

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
-- Go to current context
map("n", "[c", function() require("treesitter-context").go_to_context(vim.v.count1) end, { silent = true })

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
map({ "n", "v" }, "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, { desc = "Format code", noremap = true })
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

-- Debugging keybinds with dap and `<leader>d.`
map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle breakpoint" })
map("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
map("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run last" })

map({ "n", "v" }, "<leader>de", function() require("dapui").eval() end, { desc = "Eval expression" })
map("n", "<leader>dt", function() require("dapui").toggle() end, { desc = "DapUI close" })
map("n", "<leader>dp", function() require("dap").toggle_breakpoint(vim.fn.input("Condition: "), nil, nil) end, { desc = "Toggle _conditional_ breakpoint" })

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions", noremap = true })
map({ "n", "v" }, "<leader>fs", function() require("grug-far").open() end, { desc = "Grug far", noremap = true })

-- VSCode mappings
map("n", "<F5>", function() require("dap").continue() end)
map("n", "<F10>", function() require("dap").step_over() end)
map("n", "<F11>", function() require("dap").step_into() end)
map("n", "<F12>", function() require("dap").step_out() end)

map({ "n", "v" }, "<Leader>dh", function() require("dap.ui.widgets").hover() end)
map("n", "<Leader>dw", function() local widgets = require("dap.ui.widgets") widgets.centered_float(widgets.scopes) end)

-- Send selection to repl
map("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle repl" })
-- map("v", "<leader>ds", function() require('dap').repl.run() end, { desc = "Send selection to repl" })

-- Step commands; To be able to repeat them with a simple <M-r> click we need a helper function and variable.
local last_dap_step = nil
local function repeat_last_step()
	if last_dap_step then
		last_dap_step()
	else
		print("No previous step action")
	end
end

local function set_last_step(fn)
	last_dap_step = fn
	fn()
end

map("n", "<leader>dn", function() set_last_step(require("dap").step_over) end, { desc = "Step Over", noremap = true, silent = true })
map("n", "<leader>di", function() set_last_step(require("dap").step_into) end, { desc = "Step Into", noremap = true, silent = true })
map("n", "<leader>do", function() set_last_step(require("dap").step_out) end, { desc = "Step Out", noremap = true, silent = true })
map("n", "<leader>du", function() set_last_step(require("dap").up) end, { desc = "Step Out", noremap = true, silent = true })
map("n", "<leader>dd", function() set_last_step(require("dap").down) end, { desc = "Step Out", noremap = true, silent = true })
map("n", "<M-r>", function() repeat_last_step() end, { desc = "Repeat Last Step", noremap = true, silent = true })

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

-- timber logs
map("n", "glt", function() require("timber.actions").insert_log({ templates = { before = "time_start", after = "time_end" }, position = "surround" }) end, { desc = "[G]o [L]og [T]ime" })

map("n", "glh", function() require("timber.actions").insert_log({ template = "file", position = "below" }) end, { desc = "[G]o [L]og [H]ere: With location" })
map("n", "glc", function() require("timber.actions").clear_log_statements({ global = false }) end, { desc = "[G]o [L]og [C]lean" })
map("n", "glp", function() require("timber.actions").insert_log({ template = "pretty", position = "below" }) end, { desc = "[G]o [L]og [P]retty print" })

-- Toggle twilight/zenmode
map("n", "<leader>tt", "<cmd>Twilight<cr>", { desc = "Toggle Twilight", })
map("n", "<leader>tz", "<cmd>ZenMode<cr>", { desc = "Toggle Twilight", })

-- Toggle transparency on <leader>to
map("n", "<leader>to", function() require("base46").toggle_transparency() end, { desc = "Toggle transparency" })

map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
map("n", "]f", function() require("todo-comments").jump_next({ keywords = { "FIX", "HACK" } }) end, { desc = "Next error/warning todo comment" })
map("n", "[f", function() require("todo-comments").jump_prev({ keywords = { "FIX", "HACK" } }) end, { desc = "Next error/warning todo comment" })

-- Obsidian keybinds
map("n", "<leader>oo", ":cd $O_VAULT_DIR<CR>", { desc = "Open Obsidian notes" })
map("n", "<leader>on", ":ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>", { desc = "Insert obsidian default note template" })
map("n", "<leader>od", ":ObsidianToday<cr>", { desc = "Open today's daily note" })
map("n", "<leader>of", ":s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>", { desc = "Strip date from title" })
map("n", "<leader>os", function() require("fzf-lua").files({ cwd = "$O_VAULT_DIR" }) end, { desc = "find file in obsidian notes" })
map("n", "<leader>oz", function() vim.cmd('FzfLua live_grep cwd="$O_VAULT_DIR"') end, { desc = "grep in obsidian notes" })
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




local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<C-a>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-q>", function() ls.jump(-1) end, { silent = true })
