-- Replaces christoomey/vim-tmux-navigator.

local function multiplexer()
	if vim.env.ZELLIJ then
		return "zellij"
	elseif vim.env.TMUX then
		return "tmux"
	end
	return nil
end

return {
	"mrjones2014/smart-splits.nvim",
	init = function()
		vim.g.smart_splits_multiplexer_integration = multiplexer() or false
	end,
	-- stylua: ignore start
	keys = {
		{ "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Window left" },
		{ "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Window right" },
		{ "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Window down" },
		{ "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Window up" },
	},
	-- stylua: ignore end
	opts = {
		multiplexer_integration = multiplexer(),
		at_edge = "wrap",
	},
}
