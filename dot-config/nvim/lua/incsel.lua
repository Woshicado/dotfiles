--[[ Incremental selection on the treesitter tree: <CR> selects the node under the
     cursor, <CR> again grows to the parent, <BS> shrinks back. A per-buffer stack
     remembers the path so shrinking retraces the exact nodes that were expanded. ]]

local M = {}

---@type table<integer, TSNode[]>
local stacks = {}

local function select_node(node)
	local sr, sc, er, ec = node:range()
	-- node ranges are end-exclusive; (er, 0) means "end of the previous line"
	if ec == 0 then
		er = er - 1
		ec = #vim.api.nvim_buf_get_lines(0, er, er + 1, true)[1]
	end
	if vim.fn.mode():find("^[vV\22]") then
		vim.cmd("normal! \27")
	end
	vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
	vim.cmd("normal! v")
	vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
end

local function same_range(a, b)
	local a1, a2, a3, a4 = a:range()
	local b1, b2, b3, b4 = b:range()
	return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
end

--- Node covering the current visual selection (or cursor), inside injections too.
local function node_at_selection()
	local ok, parser = pcall(vim.treesitter.get_parser, 0)
	if not ok or not parser then
		return nil
	end
	parser:parse(true)
	local s = vim.fn.getpos("v")
	local e = vim.fn.getpos(".")
	if s[2] > e[2] or (s[2] == e[2] and s[3] > e[3]) then
		s, e = e, s
	end
	return parser:named_node_for_range({ s[2] - 1, s[3] - 1, e[2] - 1, e[3] }, { ignore_injections = false })
end

function M.start()
	local ok, node = pcall(vim.treesitter.get_node, { ignore_injections = false })
	if not ok or not node then
		return
	end
	stacks[vim.api.nvim_get_current_buf()] = { node }
	select_node(node)
end

function M.expand()
	local buf = vim.api.nvim_get_current_buf()
	local stack = stacks[buf]
	local node = stack and stack[#stack] or node_at_selection()
	if not node then
		return
	end
	if not stack then
		stack = { node }
		stacks[buf] = stack
	end
	local parent = node:parent()
	while parent and same_range(parent, node) do
		parent = parent:parent()
	end
	if not parent then
		-- top of an injected tree: continue in the host language's tree
		local sr, sc, er, ec = node:range()
		local root = vim.treesitter.get_parser(0):named_node_for_range({ sr, sc, er, ec })
		if root and not same_range(root, node) then
			parent = root
		end
	end
	if not parent then
		return
	end
	table.insert(stack, parent)
	select_node(parent)
end

function M.shrink()
	local stack = stacks[vim.api.nvim_get_current_buf()]
	if not stack or #stack < 2 then
		return
	end
	table.remove(stack)
	select_node(stack[#stack])
end

vim.api.nvim_create_autocmd("BufDelete", {
	group = vim.api.nvim_create_augroup("IncselCleanup", { clear = true }),
	callback = function(ev)
		stacks[ev.buf] = nil
	end,
})

return M
