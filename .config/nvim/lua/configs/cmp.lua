local config = require "nvchad.configs.cmp"
local cmp = require "cmp"

config.mapping["<CR>"] = cmp.mapping.confirm {
  behavior = cmp.ConfirmBehavior.Insert,
  select = false,
}

config.completion = {
  completeopt = "menu,menuone,noselect",
}

config.preselect = cmp.PreselectMode.None

-- config.window = {
--   completion = cmp.config.window.bordered(),
--   documentation = cmp.config.window.bordered(),
-- }

return config
