local M = {}

local state = { buf = nil, win = nil }

local function open()
	if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
		state.buf = vim.api.nvim_create_buf(false, true)
	end

	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		row = math.floor(vim.o.lines * 0.3),
		col = math.floor(vim.o.columns * 0.25),
		width = math.floor(vim.o.columns * 0.5),
		height = math.floor(vim.o.lines * 0.4),
		border = "rounded",
	})

	vim.wo[state.win].number = false
	vim.wo[state.win].relativenumber = false
	vim.wo[state.win].signcolumn = "no"

	-- only spawn a shell the first time; afterwards the buffer is already a terminal
	if vim.bo[state.buf].buftype ~= "terminal" then
		vim.fn.jobstart(vim.o.shell, { term = true })
		vim.bo[state.buf].buflisted = false
		vim.bo[state.buf].bufhidden = "hide"
	end

	vim.cmd("startinsert")
end

function M.toggle()
	if state.win and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, true)
		state.win = nil
	else
		open()
	end
end

return M
