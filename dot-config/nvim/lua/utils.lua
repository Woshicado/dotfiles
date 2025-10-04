local M = {}

M.map = function(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

M.is_empty_line = function()
	return vim.fn.getline("."):match("^%s*$")
end

M.is_visual_selection_empty = function()
	local mode = vim.fn.mode()
	if mode ~= "v" and mode ~= "V" and mode ~= "" then
		return false
	end

	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	if start_pos[2] > end_pos[2] then
		start_pos, end_pos = end_pos, start_pos
	end

	local start_line = start_pos[2]
	local start_col = start_pos[3]
	local end_line = end_pos[2]
	local end_col = end_pos[3]

	if start_line == end_line then
		local line = vim.fn.getline(start_line)
		local selection = string.sub(line, start_col, end_col)
		return selection:match("^%s*$")
	end

	-- Check first line
	local first_line = vim.fn.getline(start_line)
	if not string.sub(first_line, start_col):match("^%s*$") then
		return false
	end

	-- Check lines in between
	for i = start_line + 1, end_line - 1 do
		if not vim.fn.getline(i):match("^%s*$") then
			return false
		end
	end

	-- Check last line
	local last_line = vim.fn.getline(end_line)
	if not string.sub(last_line, 1, end_col):match("^%s*$") then
		return false
	end

	return true
end

M.open_or_create_session = function(path)
	-- Construct the session file path (depends on how sessions are stored)
	local absolute_path = vim.fn.fnamemodify(path, ":p")
	absolute_path = absolute_path:sub(1, -2)
	local encoded_path = absolute_path:gsub("/", "%%2F"):gsub("%.", "%%2E")
	local session_file = vim.fn.stdpath("data") .. "/sessions/" .. encoded_path .. ".vim"

	if vim.fn.filereadable(session_file) == 1 then
		-- If the session file exists, restore the session
		require("auto-session").RestoreSession(vim.fn.fnameescape(path))
	else
		-- If the session file does not exist, open fzf-lua
		-- require("fzf-lua").files({ cwd = path })
		vim.cmd("cd " .. path)
		require("oil").open(path)
	end
end

M.toggle_diffview = function(cmd)
	if next(require("diffview.lib").views) == nil then
		vim.cmd(cmd)
	else
		vim.cmd("DiffviewClose")
	end
end

return M
