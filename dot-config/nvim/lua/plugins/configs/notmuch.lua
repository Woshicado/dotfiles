return {
	"woshicado/notmuch.nvim",
	cmd = {
		"Notmuch",
		"NmSearch",
		"Inbox",
		"ComposeMail",
	},
	-- stylua: ignore start
	keys = {
		{ "<leader>nm", "<CMD>Notmuch<CR>", desc = "Open Notmuch email client" },
		{ "<leader>ni", "<CMD>Inbox<CR>", desc = "Open Notmuch inbox" },
		{ "<leader>nt", "<CMD>NmSearch tag:inbox and date:today<CR>", desc = "Open todays inbox" },
		{ "<leader>nd", "<CMD>NmSearch tag:todo<CR>", desc = "Open ToDos" },
		{ "<leader>np", "<CMD>NmSearch tag:important<CR>", desc = "Open important" },
		{ "<leader>nw", "<CMD>NmSearch tag:inbox and date:week<CR>", desc = "Open this week's inbox" },
		{ "<leader>nc", "<CMD>ComposeMail<CR>", desc = "Compose mail" },
	},
	-- stylua: ignore end
	opts = {
		render_html_body = true, -- Render HTML emails inline (requires w3m)
	},
}
