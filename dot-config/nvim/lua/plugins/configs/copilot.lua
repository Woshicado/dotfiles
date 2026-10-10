--[[ Off by default. I found myself calling `:Copilot disable` in almost every buffer.
     The language server is the `copilot-language-server` binary installed via mise.]]
return {
	"github/copilot.vim",
	cmd = "Copilot",
	init = function()
		vim.g.copilot_no_tab_map = true
		vim.g.copilot_enabled = 0
		vim.g.copilot_command = { "copilot-language-server" }
	end,
	config = function()
		vim.fn["copilot#Init"]()
		vim.cmd("doautocmd <nomodeline> github_copilot FileType")

		vim.keymap.set("i", "<C-c>", 'copilot#Accept("")', { expr = true, replace_keycodes = false, desc = "Copilot accept" })
		vim.keymap.set("i", "<C-f>", "<Plug>(copilot-accept-line)", { desc = "Copilot accept line" })
	end,
}
