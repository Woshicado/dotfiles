local function usercmd(name, fn)
	vim.api.nvim_buf_create_user_command(0, name, fn, {})
end
local map = vim.keymap.set

-- Indentation

local o = vim.opt_local

o.tabstop = 2
o.shiftwidth = 0
o.softtabstop = -1
o.expandtab = true

-- Quotes and Callouts

local function quote(callout)
	local firstline = vim.fn.line("v")
	local lastline = vim.api.nvim_win_get_cursor(0)[1]
	local r = vim.fn.winsaveview()
	if callout then
		vim.fn.append(firstline - 1, "[!Callout Text]")
	end
	if firstline == lastline then
		vim.cmd("s/^/> /")
	else
		vim.cmd(firstline .. "," .. lastline .. "s/^/> /")
	end
	vim.fn.winrestview(r)
	vim.cmd("noh")
end

local function unquote()
	local firstline = vim.fn.line("v")
	local lastline = vim.api.nvim_win_get_cursor(0)[1]
	local r = vim.fn.winsaveview()
	vim.cmd(firstline .. "," .. lastline .. [[g/>\s\+\[!/d]])
	if firstline == lastline then
		vim.cmd("s/^> //")
	else
		vim.cmd(firstline .. "," .. lastline .. "s/^> //")
	end
	vim.fn.winrestview(r)
end

usercmd("Quote", function()
	quote()
end)

usercmd("UnQuote", function()
	unquote()
end)

local opts = { buffer = true, silent = true }
map({ "v", "n" }, "<leader>aq", function()
	quote(false)
end, opts)
map({ "v", "n" }, "<leader>cq", function()
	quote(true)
end, opts)
map({ "v", "n" }, "<leader>rq", unquote, opts)

vim.keymap.set("n", "]]", function()
	require("vim.treesitter._headings").jump({ count = 1 })
	vim.cmd("normal! zt")
end, { buffer = 0, silent = false, desc = "Jump to next section" })
vim.keymap.set("n", "[[", function()
	require("vim.treesitter._headings").jump({ count = -1 })
	vim.cmd("normal! zt")
end, { buffer = 0, silent = false, desc = "Jump to previous section" })

-- The built-in ftplugin already undoes gO / ]] / [[; only our own additions go here.
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "")
	.. "\n sil! nunmap <buffer> <leader>aq | sil! vunmap <buffer> <leader>aq"
	.. "\n sil! nunmap <buffer> <leader>cq | sil! vunmap <buffer> <leader>cq"
	.. "\n sil! nunmap <buffer> <leader>rq | sil! vunmap <buffer> <leader>rq"
	.. "\n sil! delcommand -buffer Quote | sil! delcommand -buffer UnQuote"
	.. "\n setl ts< sw< sts< et<"
