return {
	"nvim-tree/nvim-tree.lua",
	config = function()
		require("nvim-tree").setup({
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")

				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				api.config.mappings.default_on_attach(bufnr)

				local options = vim.bo[bufnr].ft == "NvimTree" and "nvimtree" or "default"
				vim.keymap.set("n", "<C-t>", function()
					require("menu").open(options)
				end, opts("Context Menu"))
			end,
		})
	end,
}

