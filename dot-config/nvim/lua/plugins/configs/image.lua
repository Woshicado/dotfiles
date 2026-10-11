return {
	"3rd/image.nvim",
	build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
	ft = { "markdown", "vimwiki", "html" },
	opts = {
		backend = "kitty", -- or "ueberzug" or "sixel"
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				only_render_image_at_cursor_mode = "popup", -- or "inline"
				floating_windows = false, -- if true, images will be rendered in floating markdown windows
				filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
			},
			html = {
				enabled = true,
				only_render_image_at_cursor = true,
				--[[ Do NOT add "markdown" here. This integration calls vim.treesitter.get_parser(buf, "html"),
					   the markdown one get_parser(buf, "markdown"). Neovim caches one parser per buffer, so
						 alternating languages creates a new parser on every render while the replaced one stays
						 attached (on_bytes) until the buffer is unloaded. Leaked parsers piled up with every edit
						 and each keystroke ran LanguageTree:_edit on all of them -- THIS IS WHAT CAUSED MY LAG ]]
				filetypes = { "html", "xhtml", "htm" },
			},
		},
	},
}
