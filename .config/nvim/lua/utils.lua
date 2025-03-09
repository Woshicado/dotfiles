local M = {}

M.map = function(mode, lhs, rhs, opts)
	local options = { noremap = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

M.is_empty_line = function()
	local current_line = vim.api.nvim_get_current_line()
	return current_line:match("^%s*$") ~= nil
end

M.open_or_create_session = function(path)
	-- Construct the session file path (depends on how sessions are stored)
	local absolute_path = vim.fn.fnamemodify(path, ":p")
	absolute_path = absolute_path:sub(1, -2)
	local encoded_path = absolute_path:gsub("/", "%%2F"):gsub("%.", "%%2E")
	local session_file = vim.fn.stdpath("data") .. "/sessions/" .. encoded_path .. ".vim"

	if vim.fn.filereadable(session_file) == 1 then
		-- If the session file exists, restore the session
      print("🪵0TJ" .. path .. "0TJ")
		  require("auto-session").RestoreSession(vim.fn.fnameescape(path))
	else
		-- If the session file does not exist, open fzf-lua
    -- require("fzf-lua").files({ cwd = path })
    vim.cmd("cd " .. path)
    require("oil").open(path)
	end
end

return M
