local utils = require("utils")

local map = vim.keymap.set

-- Right click menu
-- Keyboard users
vim.keymap.set("n", "<C-t>", function()
	require("menu").open("default")
end, {})

-- mouse users + nvimtree users!
-- vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
-- 	require("menu.utils").delete_old_menus()
--
-- 	vim.cmd.exec('"normal! \\<RightMouse>"')
--
-- 	-- clicked buf
-- 	local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
-- 	local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"
--
-- 	require("menu").open(options, { mouse = true })
-- end, {})

-- Toggle checkbox in markdown [ ] <--> [x]
-- map(
--   {'n' },
--   '<leader>tt',
--   function()
--     local line = vim.api.nvim_get_current_line()
--     local modified_line = line:gsub("(- %[)(.)(%])",
--       function(prefix, checkbox, postfix)
--         checkbox = (checkbox == " ") and "x" or " "
--         return prefix .. checkbox .. postfix
--     end)
--     vim.api.nvim_set_current_line(modified_line)
--   end,
--   {
--     desc = 'ftplugin - toggle checkboxes',
--     buffer = true,
--   }
-- )

-- don't copy empty lines on deletion
map("n", "dd", function()
	return utils.is_empty_line() and '"_dd' or "dd"
end, { expr = true, desc = "delete blank lines to black hole register" })
-- map("n", "S", function()
-- 	return utils.is_empty_line() and '"_S' or "S"
-- end, { expr = true, desc = "delete blank lines to black hole register" })
-- map("n", "s", function()
-- 	return utils.is_empty_line() and '"_s' or "s"
-- end, { expr = true, desc = "delete blank lines to black hole register" })
map("n", "C", function()
	return utils.is_empty_line() and '"_C' or "C"
end, { expr = true, desc = "delete blank lines to black hole register" })

-- map("v", "d", function()
-- 	return utils.is_visual_selection_empty() and '"_d' or "d"
-- end, { expr = true, desc = "delete blank lines to black hole register" })

local function match_case(from, to)
	if from:upper() == from then
		return to:upper()
	elseif from:sub(1, 1):upper() == from:sub(1, 1) then
		return to:sub(1, 1):upper() .. to:sub(2)
	else
		return to
	end
end

local toggles = {
	["true"] = "false",
	["always"] = "never",
	["yes"] = "no",
	["on"] = "off",
	["enable"] = "disable",
	["up"] = "down",
	["left"] = "right",
	["in"] = "out",
	["next"] = "previous",
  ["public"] = "private",
}

local function ToggleWord()
	local cword = vim.fn.expand("<cword>")
	local newWord
	for word, opposite in pairs(toggles) do
		if cword:lower() == word then
			newWord = match_case(cword, opposite)
			break
		elseif cword:lower() == opposite then
			newWord = match_case(cword, word)
			break
		end
	end
	if newWord then
		local prevCursor = vim.api.nvim_win_get_cursor(0)
		vim.cmd.normal({ '"_ciw' .. newWord, bang = true })
		vim.api.nvim_win_set_cursor(0, prevCursor)
	end
end

vim.keymap.set({ "n", "i" }, "<M-t>", ToggleWord, { desc = "Toggle word under cursor" })
vim.keymap.set({ "n" }, "<leader>tw", ToggleWord, { desc = "Toggle word under cursor" })
