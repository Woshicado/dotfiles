return {
	url = "https://codeberg.org/andyg/leap.nvim",
	keys = {
		{ "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward" },
    -- { "S", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from window" },
	},
	config = function()
		require("leap").setup({})

    -- Recommended configurations from leap docs
		require("leap").opts.preview = function(ch0, ch1, ch2)
			return not (ch1:match("%s") or (ch0:match("%a") and ch1:match("%a") and ch2:match("%a")))
		end

		do
			local clever = require("leap.user").with_traversal_keys
			-- For relative directions, set the `backward` flags according to:
			-- local prev_backward = require('leap').state['repeat'].backward
			vim.keymap.set({ "n", "x", "o" }, "<cr>", function()
				require("leap").leap({
					["repeat"] = true,
					opts = clever("<cr>", "<bs>"),
				})
			end)
			vim.keymap.set({ "n", "x", "o" }, "<bs>", function()
				require("leap").leap({
					["repeat"] = true,
					opts = clever("<bs>", "<cr>"),
					backward = true,
				})
			end)
		end
	end,
}
