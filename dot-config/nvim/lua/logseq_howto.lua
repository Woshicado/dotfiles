-- Fuzzy-find the #Howto notes kept in Logseq
--
-- The notes live in the graph's database, not in files, so there is nothing to
-- grep: scripts/howto.js in the logseq-config folder asks Logseq for them and
-- feeds fzf. Matching runs over the whole text, code included.
--
-- M.pick()    one line per how-to; the preview is the whole page
--   <CR>     open the whole how-to in a scratch buffer beside the current one
--   ctrl-y   yank the whole how-to
--   ctrl-b   switch to the block picker
--   ctrl-o   open it in Logseq
--
-- M.blocks()  one line per block, for when you want one snippet out of a page
--   <CR>     yank the block's text (unnamed and system clipboard)
--   ctrl-p   put it below the cursor
--   ctrl-e   open the whole how-to in a scratch buffer, cursor on that block
--   ctrl-o   open the block in Logseq

local M = {}

M.script = vim.g.logseq_howto_script
	or vim.fn.expand("~/projects/logseq-plugins/logseq-config/scripts/howto.js")
M.graph = vim.env.LOGSEQ_GRAPH or "logseq-obs-copy"

local function run(sub, id)
	local out = vim.fn.systemlist({ "node", M.script, sub, tostring(id) })
	if vim.v.shell_error ~= 0 then
		vim.notify(table.concat(out, "\n"), vim.log.levels.ERROR, { title = "Logseq how-to" })
		return nil
	end
	return out
end

-- The id is the first tab-separated field of the picked line.
local function id_of(selected)
	return selected and selected[1] and selected[1]:match("^(%d+)")
end

local function yank(lines)
	local text = table.concat(lines, "\n")
	vim.fn.setreg('"', text)
	vim.fn.setreg("+", text)
	vim.notify(#lines .. (#lines == 1 and " line" or " lines") .. " yanked", vim.log.levels.INFO, { title = "Logseq how-to" })
end

function M.yank_block(selected)
	local id = id_of(selected)
	local lines = id and run("text", id)
	if lines then
		yank(lines)
	end
end

function M.yank_page(selected)
	local id = id_of(selected)
	local lines = id and run("page", id)
	if lines then
		yank(lines)
	end
end

function M.put(selected)
	local id = id_of(selected)
	local lines = id and run("text", id)
	if lines then
		vim.api.nvim_put(lines, "l", true, true)
	end
end

-- The whole how-to that `selected` is, or belongs to, in a scratch buffer
-- beside the current window: to the right when there is room, below otherwise.
-- One window is reused, so picking another how-to replaces the last one.
function M.open_page(selected)
	local id = id_of(selected)
	local lines = id and run("page", id)
	if not lines then
		return
	end
	local at = tonumber((run("line", id) or {})[1]) or 1

	local win
	for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.b[vim.api.nvim_win_get_buf(w)].logseq_howto then
			win = w
			break
		end
	end
	if win then
		vim.api.nvim_set_current_win(win)
		vim.cmd("enew")
	else
		vim.cmd(vim.o.columns >= 160 and "rightbelow vnew" or "rightbelow new")
	end

	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.b[buf].logseq_howto = true
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modified = false
	vim.bo[buf].filetype = "markdown"
	pcall(vim.api.nvim_buf_set_name, buf, "howto://" .. (lines[1] or ""):gsub("^#%s*", ""))
	vim.api.nvim_win_set_cursor(0, { math.min(at, #lines), 0 })
	vim.cmd("normal! zt")
end

function M.open_logseq(selected)
	local id = id_of(selected)
	local uuid = id and run("uuid", id)
	if uuid and uuid[1] then
		vim.ui.open("logseq://graph/" .. M.graph .. "?block-id=" .. uuid[1])
	end
end

local function picker(feed, preview_cmd, prompt, actions)
	local node = "node " .. vim.fn.shellescape(M.script)
	local preview = node .. " " .. preview_cmd .. " {1}"
	if vim.fn.executable("bat") == 1 then
		preview = preview .. " | bat --language=markdown --style=plain --color=always"
	end
	require("fzf-lua").fzf_exec(node .. " " .. feed, {
		prompt = prompt,
		preview = preview,
		fzf_opts = {
			["--delimiter"] = "\t",
			["--with-nth"] = "2..",
			-- Code is searched for what it says, not for letters in that order.
			["--exact"] = true,
			["--tiebreak"] = "begin,length",
		},
		actions = actions,
	})
end

function M.pick()
	picker("pages", "page", "How-to> ", {
		["default"] = M.open_page,
		["ctrl-y"] = M.yank_page,
		["ctrl-b"] = function() M.blocks() end,
		["ctrl-o"] = M.open_logseq,
	})
end

function M.blocks()
	picker("list", "show", "How-to block> ", {
		["default"] = M.yank_block,
		["ctrl-p"] = M.put,
		["ctrl-e"] = M.open_page,
		["ctrl-o"] = M.open_logseq,
	})
end

return M
