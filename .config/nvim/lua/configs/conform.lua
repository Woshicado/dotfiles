local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    python = { "ruff_organize_imports", "ruff_format" },
    yaml = { "yamlfix" },
    json = { "jq" },
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
