local autocmd = vim.api.nvim_create_autocmd

--[[ Strip trailing whitespace on write. Skipped where trailing spaces mean something:
     markdown (two spaces = hard line break) and mail ("-- " signature separator).
     keeppatterns/keepjumps keep the search register and jumplist clean, the view is restored. ]]
local trim_skip = { markdown = true, mail = true, diff = true }
autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("TrimTrailingWhitespace", { clear = true }),
	callback = function(ev)
		if trim_skip[vim.bo[ev.buf].filetype] or vim.bo[ev.buf].binary then
			return
		end
		local view = vim.fn.winsaveview()
		vim.cmd([[keeppatterns keepjumps %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})

if vim.env.NVIM_QUIT_ON_LAST then
	autocmd("BufDelete", {
		callback = function()
			local listed = vim.fn.getbufinfo({ buflisted = 1 })
			if #listed <= 1 then
				vim.cmd("quit")
			end
		end,
	})
end

-- Open .bin files in binary mode
vim.api.nvim_create_augroup("BinaryFiles", { clear = true })

autocmd("BufReadPre", {
	group = "BinaryFiles",
	pattern = "*.bin",
	callback = function()
		vim.opt_local.binary = true
	end,
})

autocmd("BufReadPost", {
	group = "BinaryFiles",
	pattern = "*.bin",
	callback = function()
		vim.cmd("e ++binary")
	end,
})
