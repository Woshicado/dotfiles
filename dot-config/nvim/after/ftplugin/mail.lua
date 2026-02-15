vim.bo.buftype = ""
vim.bo.modified = false
require("twilight").enable()

-- 1. Disable diagnostics (red underlines, error text)
vim.diagnostic.enable(false, { bufnr = 0 })

-- 2. Create a function to kill any LSP on this buffer
local function kill_lsp()
	-- Get all active clients for the current buffer
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	for _, client in ipairs(clients) do
		-- Detach the client so it stops processing the buffer
		vim.lsp.buf_detach_client(0, client.id)
	end
	-- Also turn off the visual diagnostics (underlines/icons)
	vim.diagnostic.enable(false, { bufnr = 0 })
end

-- 2. Run it immediately (for clients already there)
kill_lsp()

-- 3. Run it whenever a new LSP tries to attach to this buffer
vim.api.nvim_create_autocmd("LspAttach", {
	buffer = 0,
	callback = function()
		vim.schedule(kill_lsp)
	end,
})
