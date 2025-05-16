local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd" },
    html = { "prettierd" },
    python = { "ruff_organize_imports", "ruff_fix", "ruff_format" },
    yaml = { "yamlfix" },
    json = { "jq" },
    markdown = { "prettierd" },
    tex = { "latexindent" },
  },
  opts = {
    format = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
    },
  },
  formatters = {
    ruff_organize_imports = {
      command = "ruff",
      args = {
        "check",
        "--force-exclude",
        "--select=I001",
        "--fix",
        "--exit-zero",
        "--stdin-filename",
        "$FILENAME",
        "-",
      },
      stdin = true,
      cwd = require("conform.util").root_file {
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
      },
    },
  },
  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
