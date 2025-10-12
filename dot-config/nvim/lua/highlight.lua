local set_hl = vim.api.nvim_set_hl

-- General custom highlights
set_hl(0, "RenderMarkdownCode", { bg = "none" })
set_hl(0, "LineNr", { fg = "#4e535d" })

-- NEOGIT HIGHLIGHTS -- Default ones were unreadable in my theme
set_hl(0, "NeogitDiffDelete", { fg = "#ff5555", bg = "NONE" }) -- Adjust foreground color
set_hl(0, "NeogitDiffDeleteHighlight", { fg = "#ff5555", bg = "#440000" }) -- Highlighted delete lines
set_hl(0, "NeogitDiffDeleteCursor", { fg = "#ff9999", bg = "#550000" }) -- Cursor line in deleted changes
set_hl(0, "NeogitDiffDeletions", { fg = "#ff4444", bg = "NONE" }) -- Deletion indicators
set_hl(0, "NeogitChangeDeleted", { fg = "#ff2222", bg = "NONE" }) -- Changed but deleted files

-- Graph-related highlights
set_hl(0, "NeogitGraphBoldRed", { fg = "#ff4444", bold = true })
set_hl(0, "NeogitGraphRed", { fg = "#ff6666" })

-- Signature verification status
set_hl(0, "NeogitSignatureBad", { fg = "#ff3333", bg = "NONE", bold = true }) -- Bad signatures
set_hl(0, "NeogitSignatureGoodRevokedKey", { fg = "#ffaa00", bold = true }) -- Revoked key warnings

-- ufo
set_hl(0, "UfoVirtText", { fg = "#39a6d7", bg = "NONE" }) -- Ellipsis for folded text
set_hl(0, "RenderMarkdownCode", { bg = "none" })
set_hl(0, "LineNr", { fg = "#4e535d" })

-- neogit
set_hl(0, "NeogitChangeDuntracked", { fg = "#ffaa55", bg = "NONE" }) -- Untracked changes
set_hl(0, "NeogitChangeDunstaged", { fg = "#ffbb77", bg = "NONE" }) -- Unstaged changes
set_hl(0, "NeogitChangeDstaged", { fg = "#ffcc88", bg = "NONE" }) -- Staged changes
set_hl(0, "NeogitWinSeparator", { fg = "#666666", bg = "NONE" }) -- Window separators

