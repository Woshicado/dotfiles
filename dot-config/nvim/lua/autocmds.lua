local autocmd = vim.api.nvim_create_autocmd

-- auto delete trailing whitespace
autocmd({ "BufWritePre" }, {
	pattern = { "*" },
	command = [[%s/\s\+$//e]],
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
