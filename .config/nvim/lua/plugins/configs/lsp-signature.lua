return {
	"ray-x/lsp_signature.nvim",
  lazy = false,
	config = function()
		require("lsp_signature").setup({
			bind = true,
			handler_opts = { border = "rounded" },
			floating_window = true,
			hint_enable = false,
			floating_window_above_cur_line = true,
			doc_lines = 2,
			fix_pos = true,
		})
	end,
}

