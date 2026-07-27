--[[ Ctrl-hjkl navigation across nvim windows *and* multiplexer panes. ]]

local M = {}

---@type table<string, { zellij: string, tmux: string }>
local DIRECTIONS = {
	h = { zellij = "left", tmux = "-L" },
	j = { zellij = "down", tmux = "-D" },
	k = { zellij = "up", tmux = "-U" },
	l = { zellij = "right", tmux = "-R" },
}

--- Ask the multiplexer to move focus. Async on purpose -- see the note above.
---@param dir "h"|"j"|"k"|"l"
local function handoff(dir)
	local d = DIRECTIONS[dir]
	if vim.env.ZELLIJ then
		vim.system({ "zellij", "action", "move-focus", d.zellij })
	elseif vim.env.TMUX then
		vim.system({ "tmux", "select-pane", d.tmux })
	end
end

--- Move to the nvim window in `dir`; if there is none, hand off to the multiplexer.
---@param dir "h"|"j"|"k"|"l"
function M.move(dir)
	if vim.api.nvim_win_get_config(0).relative ~= "" then
		return
	end

	local from = vim.api.nvim_get_current_win()
	vim.cmd.wincmd(dir)
	if vim.api.nvim_get_current_win() == from then
		handoff(dir)
	end
end

function M.setup()
	for dir, _ in pairs(DIRECTIONS) do
		vim.keymap.set("n", "<C-" .. dir .. ">", function()
			M.move(dir)
		end, { desc = "Window/pane " .. dir, silent = true })
	end
end

return M
