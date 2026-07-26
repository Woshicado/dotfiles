local usercmd = vim.api.nvim_create_user_command

-- Expose a command for formatting
usercmd("Format", function()
	require("conform").format()
end, {})

usercmd("BDCloseFT", function(opts)
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[buf].filetype == opts.args and not vim.bo[buf].modified then
			vim.api.nvim_buf_delete(buf, {})
		end
	end
end, { nargs = 1 })

usercmd("MacOSQuicklook", function()
	local oil = require("oil")
	local entry = oil.get_cursor_entry()
	if entry then
		local full_path = oil.get_current_dir() .. entry.name
		vim.fn.jobstart({ "qlmanage", "-p", full_path }, { detach = true })
		vim.defer_fn(function()
			vim.fn.system(
				"osascript -e 'tell application \"System Events\" to tell process \"qlmanage\"' -e 'set frontmost to true' -e 'end tell'"
			)
		end, 300) -- Delay in milliseconds
	else
		print("Can only do quicklook in Oil")
	end
end, {})
