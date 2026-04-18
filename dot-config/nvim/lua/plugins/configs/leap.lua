return {
	url = "https://codeberg.org/andyg/leap.nvim",
	keys = {
		{ "s", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward" },
    { "<C-s>", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap from window" },
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
			vim.keymap.set({ "n", "o" }, "<cr>", function()
				require("leap").leap({
					["repeat"] = true,
					opts = clever("<cr>", "<bs>"),
				})
			end)
			vim.keymap.set({ "n", "o" }, "<bs>", function()
				require("leap").leap({
					["repeat"] = true,
					opts = clever("<bs>", "<cr>"),
					backward = true,
				})
			end)
		end

		-- Integrate with / and ? searches
		vim.api.nvim_create_autocmd("CmdlineLeave", {
			group = vim.api.nvim_create_augroup("LeapOnSearch", {}),
			callback = function()
				local ev = vim.v.event
				local is_search_cmd = (ev.cmdtype == "/") or (ev.cmdtype == "?")
				local cnt = vim.fn.searchcount().total
				if is_search_cmd and not ev.abort and (cnt > 1) then
					-- Allow CmdLineLeave-related chores to be completed before
					-- invoking Leap.
					vim.schedule(function()
						-- We want "safe" labels, but no autojump (as the search
						-- command already does that), so just use `safe_labels`
						-- as `labels`, with n/N removed.
						local labels = require("leap").opts.safe_labels:gsub("[nN]", "")
						-- For `pattern` search, we never need to adjust conceallevel
						-- (no user input). We cannot merge `nil` from a table, but
						-- using the option's current value has the same effect.
						local vim_opts = { ["wo.conceallevel"] = vim.wo.conceallevel }
						require("leap").leap({
							pattern = vim.fn.getreg("/"), -- last search pattern
							windows = { vim.fn.win_getid() },
							opts = { safe_labels = "", labels = labels, vim_opts = vim_opts },
						})
					end)
				end
			end,
		})

    -- do
    -- 	local function leap_search(key, is_reverse)
    -- 		local cmdline_mode = vim.fn.mode(true):match("^c")
    -- 		if cmdline_mode then
    -- 			-- Finish the search command.
    -- 			vim.api.nvim_feedkeys(vim.keycode("<enter>"), "t", false)
    -- 		end
    -- 		if vim.fn.searchcount().total < 1 then
    -- 			return
    -- 		end
    -- 		-- Activate again if `:nohlsearch` has been used (Normal/Visual mode).
    -- 		vim.go.hlsearch = vim.go.hlsearch
    -- 		-- Allow the search command to complete its chores before
    -- 		-- invoking Leap (Command-line mode).
    -- 		vim.schedule(function()
    -- 			require("leap").leap({
    -- 				pattern = vim.fn.getreg("/"),
    -- 				-- If you always want to go forward/backward with the given key,
    -- 				-- regardless of the previous search direction, just set this to
    -- 				-- `is_reverse`.
    -- 				backward = (is_reverse and vim.v.searchforward == 1)
    -- 					or (not is_reverse and vim.v.searchforward == 0),
    -- 				opts = require("leap.user").with_traversal_keys(key, "", {
    -- 					-- Autojumping to the second match would be confusing without
    -- 					-- 'incsearch'.
    -- 					safe_labels = (cmdline_mode and not vim.o.incsearch) and ""
    -- 						-- Keep n/N usable in any case.
    -- 						or require("leap").opts.safe_labels:gsub("[nN]", ""),
    -- 				}),
    -- 			})
    -- 			-- You might want to switch off the highlights after leaping.
    -- 			-- vim.cmd('nohlsearch')
    -- 		end)
    -- 	end
    --
    -- 	vim.keymap.set({ "n", "x", "o", "c" }, "<c-s>", function()
    -- 		leap_search("<c-s>", false)
    -- 	end, { desc = "Leap to search matches" })
    --
    -- 	vim.keymap.set({ "n", "x", "o", "c" }, "<c-q>", function()
    -- 		leap_search("<c-q>", true)
    -- 	end, { desc = "Leap to search matches (reverse)" })
    -- end
	end,
}
