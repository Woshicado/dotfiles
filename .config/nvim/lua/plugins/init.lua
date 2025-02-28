return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    -- opts = require "configs.conform",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "ruff_format" },
          rust = { "rustfmt", lsp_format = "fallback" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "yamlfix" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "jq" },
        },
      }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require "configs.cmp"
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    dependencies = {
    },
    config = function()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  {
    {
      "stevearc/oil.nvim",
      ---@module 'oil'
      ---@type oil.SetupOpts
      opts = {},
      -- Optional dependencies
      -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
      dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
      -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
      lazy = false,
      config = function()
        require("oil").setup {
          -- Your configuration comes here
        }
      end,
    },
  },

  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      { "<leader>wr", "<cmd>SessionSearch<CR>", desc = "Session search" },
      { "<leader>ws", "<cmd>SessionSave<CR>", desc = "Save session" },
      { "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", desc = "Toggle autosave" },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      -- log_level = 'debug',
    },
    config = function()
      require("auto-session").setup {
        bypass_save_filetypes = { "dashboard" },
        auto_create = function()
          local cmd = "git rev-parse --is-inside-work-tree"
          return vim.fn.system(cmd) == "true\n"
        end,
        session_lens = {
          previewer = true,
          mappings = {
            -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
            delete_session = { "i", "<C-D>" },
            alternate_session = { "i", "<C-S>" },
            copy_session = { "i", "<C-Y>" },
          },
        },
      }
    end,
  },

  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      -- "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
      -- "echasnovski/mini.pick", -- optional
    },
    config = function()
      require("neogit").setup {
        graph_style = "kitty",
        telescope_sorter = function()
          return require("telescope").extensions.fzf.native_fzf_sorter()
        end,
      }
    end,
  },

  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    event = "VimEnter",
    config = function()
      require("dashboard").setup {
        -- config
        config = {
          -- header = {
          -- },
          week_header = {
            enable = true,
            --   append = {
            --     '',
            --     '                    █▓                             ',
            --     '                  ██▓█                             ',
            --     '                 ▓░░░░░▒                           ',
            --     '                ▓▒░░░░░░▓                          ',
            --     '               ██░░░░░░░░                          ',
            --     '              █▓▒░░░░░░░░▓                         ',
            --     '              ██░░░░░░░░░░                         ',
            --     '             █▓▒░░░░░░░░░░█                        ',
            --     '             ▓█░░░░░░░░░░░▒                        ',
            --     '            █▓▒░░░░░░░░░░░░█                       ',
            --     '           █▓█░░░░░░░░░░░░░░█                      ',
            --     '          █▓█░░░░░░░░░██░░░░░█                     ',
            --     '        █▓▓█░░░░░░░░░░░█░░░▓░░█                    ',
            --     '       █▓▓█░░░░░░░░░░░░█░░░░░░▒█                   ',
            --     '      █▓▓█░░░░░░░░░░░░░▓█░░░░░░░▒                  ',
            --     '     █▓▓▓░░░░░░░░░░▓█▒░░▓█░░░░░░░░░░▒█             ',
            --     '    █▓▓█░░░░░░░█▒▓▓▓▓▓▒▓▓▓█░░░░░░░░░░░░░▒█         ',
            --     '    █▓▓░░░░░░░▒█▓▓▓▓▓▓▓▓▓▓██░░░░░░░░░░░░░░░▒       ',
            --     '    ▓▓█░░░░░░▒▓▓▓▓▒▒▒▒▒▓▓▓▓█▓░░░░░░░░░░░░░░░░▓     ',
            --     '   █▓▓█░░░░░░░▓▓▓▓▒▒▒▒▒▓▓▓▓█▓░░░░░░█▓▓▓▓▓▓░░░░▒    ',
            --     '    ▓▓█░░░░░░░▒█▓▓▓▓▓▓▓▓▓▓█░▓█░░░░▒▓▓▓▓▒▒▓▓░░░░█   ',
            --     '    █▓▓█░░░░░░░░█▓▓▓▓▓▓▓▓▒░░█▓░░░░█▓▓▓▒▒▒▓█░░░░    ',
            --     '     █▓▓▓░░░░░░░░░░░▒▒░░░░░░░▓█░░░░▒█▓▓▓▓█░░░░█    ',
            --     '       █▓█░░░░░░░░░░░░░░░░░░░░▓█░░░░░░░░░░░░░█     ',
            --     '         ███▒░░░░░░░░░░░░░░░░▓ █▓█▒░░░░░░░░█       ',
            --     '              ███▓▒░░░▒▒██       ██▓█████          ',
            --     '                                                   ',
            --   }
          },
          shortcut = {
            { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = 'require("fzf-lua").files()',
              key = "f",
            },
            {
              desc = " Apps",
              group = "DiagnosticHint",
              action = "Telescope app",
              key = "a",
            },
            {
              desc = " dotfiles",
              group = "Number",
              action = "Telescope dotfiles",
              key = "d",
            },
          },
          project = {
            enable = true,
            limit = 8,
            action = function(path)
              -- Construct the session file path (depends on how sessions are stored)
              local absolute_path = vim.fn.fnamemodify(path, ":p")
              absolute_path = absolute_path:sub(1, -2)
              local encoded_path = absolute_path:gsub("/", "%%2F"):gsub("%.", "%%2E")
              local session_file = vim.fn.stdpath "data" .. "/sessions/" .. encoded_path .. ".vim"

              if vim.fn.filereadable(session_file) == 1 then
                -- If the session file exists, restore the session
                vim.cmd("SessionRestore " .. vim.fn.fnameescape(path))
              else
                -- If the session file does not exist, open fzf-lua
                require("fzf-lua").files { cwd = path }
              end
            end,
          },
          mru = { enable = true, limit = 10, cwd_only = false },
        },
        preview = {
          command = "cat",
          file_path = "~/.config/nvim/lua/db_text",
          file_height = 27,
          file_width = 58,
        },
      }
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    opts = {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
    },
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "c",
        "cpp",
        "markdown",
        "markdown_inline",
        "python",
        "json",
        "yaml",
        "xml",
        "bash",
      },

      indent = {
        enable = true,
        disable = {},
      },
      highlight = {
        enable = true,
        disable = {},
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "andrew-george/telescope-themes",
    },
    opts = {
      extensions_list = { "themes", "fzf" },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
      },
    },
    config = function()
      -- load extension
      local telescope = require "telescope"
      telescope.load_extension "themes"
    end,
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup {
        diff = {
          algorithm = "patience",
          ignore_whitespace = true,
          ctxlen = 3,
        },

        telescope = {
          sorting_strategy = "ascending",
          layout_strategy = "vertical",
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = "top",
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },

        -- priority list of external command to highlight diff
        -- disabled by default, must be set by yourself
        highlight_command = {
          require("actions-preview.highlight").delta(),
          -- require("actions-preview.highlight").diff_so_fancy(),
          -- require("actions-preview.highlight").diff_highlight(),
        },

        backend = { "telescope", "minipick", "snacks", "nui" },
      }
    end,
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "lervag/vimtex",
    -- lazy = false,
    init = function()
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_syntax_conceal = {
        acents = 1,
        ligatures = 1,
        cites = 1,
        fancy = 1,
        spacing = 0,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 0,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }

      -- Use init for configuration, don't use the more common "config".
    end,
  },

  {
    "ibhagwan/fzf-lua",
    lazy = false,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "echasnovski/mini.icons" },
    opts = {},
    config = function()
      require("fzf-lua").setup {
        "border-fused",
        -- your other settings here
      }
    end,
  },

  {
    "nvzone/volt",
    lazy = true,
  },

  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },

  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
}
