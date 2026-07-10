return {
	-- very expensive and not worth it functionality-wise ig.
	-- E.g., makes large blockquotes in markdown files insanely slow
	"andymass/vim-matchup",
	event = "VeryLazy",
	opts = {
		treesitter = {
			stopline = 500,
		},
	},
	init = function()
		vim.g.matchup_matchparen_deferred = 1 -- highlight off the main loop, never blocks cursor
		vim.g.matchup_matchparen_timeout = 100 -- cap the search budget
		vim.g.matchup_matchparen_deferred_show_delay = 50
		vim.g.matchup_delim_stopline = 300 -- don't scan the whole buffer
	end,
}
