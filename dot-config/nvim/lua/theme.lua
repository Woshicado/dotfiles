--[[ Light/dark switching, with Neovim as the source of truth.

     `toggle`/`set` flip 'background' (kanagawa maps dark -> wave, light -> lotus)
     and then shell out to `theme-switch`, which propagates to kitty and lsd.
     Everything about *how* other tools are switched lives in that script, so the
     same toggle works from a plain shell.

     The reverse direction is handled too: the terminal is asked to report
     colour-scheme changes (kitty's OSC 2031), so if kitty's theme changes from
     outside -- a macOS appearance change picking up its *-theme.auto.conf, or
     another `theme-switch` invocation -- a running Neovim follows instead of
     ending up with, say, a light cursor on a dark colorscheme.

     No feedback loop: the inbound path only ever sets 'background', it never
     pushes back out. ]]

local M = {}

---@param bg "dark"|"light"
local function propagate(bg)
	if vim.fn.executable("theme-switch") == 0 then
		return
	end
	vim.system({ "theme-switch", bg }, { text = true }, function(res)
		if res.code ~= 0 then
			local err = res.stderr ~= "" and res.stderr or res.stdout
			vim.schedule(function()
				vim.notify("theme-switch failed: " .. tostring(err), vim.log.levels.WARN)
			end)
		end
	end)
end

--- Set the theme here and everywhere else.
---@param bg "dark"|"light"
function M.set(bg)
	if vim.o.background ~= bg then
		vim.o.background = bg -- kanagawa re-loads itself off this
	end
	propagate(bg)
end

function M.toggle()
	M.set(vim.o.background == "dark" and "light" or "dark")
end

--- Follow a change that came *from* the terminal. Deliberately does not propagate.
---@param bg "dark"|"light"
local function follow(bg)
	if vim.o.background ~= bg then
		vim.o.background = bg
	end
end

function M.setup()
	local group = vim.api.nvim_create_augroup("ThemeFollowTerminal", { clear = true })

	-- Subscribe to colour-scheme change notifications. Neovim 0.12 handles OSC 11
	-- responses on its own but never asks for these, so we opt in explicitly.
	if vim.env.KITTY_LISTEN_ON or vim.env.TERM == "xterm-kitty" then
		pcall(vim.api.nvim_ui_send, "\27[?2031h")

		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = group,
			desc = "Stop asking the terminal for colour-scheme notifications",
			callback = function()
				pcall(vim.api.nvim_ui_send, "\27[?2031l")
			end,
		})
	end

	vim.api.nvim_create_autocmd("TermResponse", {
		group = group,
		desc = "Follow terminal colour-scheme changes",
		callback = function(ev)
			local seq = type(ev.data) == "table" and ev.data.sequence or nil
			if type(seq) ~= "string" then
				return
			end
			-- kitty answers CSI ? 997 ; 1 n for dark and CSI ? 997 ; 2 n for light
			local n = seq:match("^\27%[%?997;(%d)n$")
			if n then
				follow(n == "1" and "dark" or "light")
			end
		end,
	})
end

return M
