return {
  defaults = { lazy = true },
  install = { colorscheme = { "kanagawa" } },

  -- Plugins with `dev = true` are loaded from here instead of being cloned.
  dev = { path = "~/projects", patterns = {}, fallback = true },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  performance = {
    rtp = {
      -- Names are matched against $VIMRUNTIME/plugin/*.{vim,lua} basenames; anything
      -- else (netrw, syntax, ftplugin, ...) would be a silent no-op.
      disabled_plugins = {
        "gzip",
        "matchit",
        "netrwPlugin",
        "rplugin",
        "spellfile", -- no auto-download prompt for missing spell files
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
}
