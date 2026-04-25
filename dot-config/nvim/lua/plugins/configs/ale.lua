return {
	"dense-analysis/ale",
	lazy = false,
	config = function()
		-- Configuration goes here.
		local g = vim.g

		g.ale_ruby_rubocop_auto_correct_all = 1

		g.ale_lint_on_text_changed = "never"
		g.ale_lint_on_insert_leave = 0
		g.ale_lint_on_enter = 0
		g.ale_lint_on_save = 1

		g.ale_set_loclist = 0
		g.ale_set_quickfix = 1

		g.ale_disable_lsp = 1 -- ?

		g.ale_linters = {
			markdown = { "vale" },
		}
		g.ale_virtualtext_cursor = 0
		g.ale_echo_cursor = 0

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				local lines = vim.api.nvim_buf_get_lines(0, 0, 10, false)
				for _, line in ipairs(lines) do
					if line:match("^lang:%s*de") then
						vim.b.ale_linters = { markdown = {} }
						return
					end
				end
			end,
		})
	end,
}
