return {
  -- conform.nvim (formatter)
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    -- opts = require "configs.conform",
    config = function()
      require("conform").setup(require "configs.conform")
    end,
  },

  -- Render markdowns in normal mode
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    lazy = false,
    config = function()
      require("render-markdown").setup {
        completions = { lsp = { enabled = true } },
      }
    end,
  },

  -- Markdown tables
  -- {
  --   -- I feel like this table plugin does not really work well with rendered tables? Or whatever, some issues
  --   "dhruvasagar/vim-table-mode",
  --   lazy = false,
  -- },

  -- obsidian.nvim (Edit, search, ... obsidian notes in Neovim)
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vaults/obsidian-notes/",
        },
      },
      notes_subdir = "inbox",
      new_notes_location = "notes_subdir",
      templates = {
        subdir = "Extras/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      -- Optional, override the 'gf' keymap to utilize Obsidian's search functionality.
      -- see also: 'follow_url_func' config option above.
      vim.keymap.set("n", "gd", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gd"
        end
      end, { noremap = false, expr = true })
    end,
  },

  -- nvim-dap (Debugging Adapter Protocol; debugging common)
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      -- dap.listeners.before.event_terminated.dapui_config = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited.dapui_config = function()
      --   dapui.close()
      -- end
    end,
  },

  -- fzf (Needed as dependency for neogit; otherwise I am using fzf-lua)
  {
    "junegunn/fzf",
    build = "./install --bin",
    lazy = false,
  },

  -- nvim-dap-ui (debugging UI)
  {
    "rcarriga/nvim-dap-ui",
    lazy = false,
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },

  -- nvim-dap-python (python debugger server)
  {
    "mfussenegger/nvim-dap-python",
    lazy = false,
    config = function()
      require("dap-python").setup(
        "/Users/joshua/.virtualenvs/base/bin/python",
        { console = "integratedTerminal", include_configs = false }
      )
      local dap = require "dap"
      local configs = dap.configurations.python or {}
      dap.configurations.python = configs
      table.insert(configs, {
        type = "debugpy",
        request = "launch",
        name = "Debug file",
        program = "${file}",
        -- ... more options, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
        -- env = { DEBUGPY_LOG_DIR= "${workspaceFolder}/.daplogs" }, -- enables debuglogs in local dir
        console = "integratedTerminal",
        justMyCode = false,
        logToFile = true,
        showReturnValue = true,
        stopOnEntry = true,
      })

      -- TODO: I guess use argparse at some point to make this more robust
      vim.g.last_debugpy_command = vim.g.last_debugpy_command or ""

      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Debug custom",
        program = function()
          local parts = vim.split(vim.g.last_debugpy_command, " ")
          return parts[1] -- First part is the script
        end,
        args = function()
          vim.g.last_debugpy_command = vim.fn.input("Command: ", vim.g.last_debugpy_command or "")
          local parts = vim.split(vim.g.last_debugpy_command, " ")
          return vim.list_slice(parts, 2)
        end,
        console = "integratedTerminal",
        justMyCode = false,
        logToFile = true,
        showReturnValue = true,
        stopOnEntry = false,
      })

      require("dap").defaults.fallback.external_terminal = {
        command = "/opt/homebrew/bin/kitty",
        args = { "--hold" },
      }
    end,
  },

  -- timber (Better logs)
  {
    "Goose97/timber.nvim",
    version = "*",
    opts = {},
    event = "VeryLazy",
    config = function()
      require("timber").setup {
        log_marker = "🪵",
        log_templates = {
          default = {
            lua = [[print("%watcher_marker_start" .. %log_target .. "%watcher_marker_end")]],
            python = [[print(f"%watcher_marker_start|\033[0;32m{%log_target=}\033[0m|%watcher_marker_end")]],
          },
          file = {
            python = [[print(f"%watcher_marker_start|LOG \033[0;32m{%log_target=}\033[0m ON LINE \033[0;33m%filename:%line_number\033[0m|%watcher_marker_end")]],
          },
          time_start = {
            lua = [[local _start = os.time()]],
            python = [[import time; _start = time.perf_counter()]],
          },
          time_end = {
            lua = [[print("Elapsed time: " .. tostring(os.time() - _start) .. " seconds")]],
            python = [[print(f"%watcher_marker_start|Elapsed time: \033[0;34m{time.perf_counter() - _start}\033[0m seconds|%watcher_marker_end")]],
          },
          pretty = {
            python = [[from pprint import pformat; print(f"%watcher_marker_start|\033[0;32m%log_target = {pformat(%log_target)}\033[0m|%watcher_marker_end")]],
          },
        },
        log_watcher = {
          enabled = true,
          -- A table of source id and source configuration
          sources = {
            log_file = {
              type = "filesystem",
              name = "Log file",
              path = "/tmp/debug.log",
            },
          },
        },
      }
    end,
  },

  -- nvim-tree (Tree file explorer)
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
        on_attach = function(bufnr)
          local api = require "nvim-tree.api"

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          -- default mappings
          api.config.mappings.default_on_attach(bufnr)

          -- custom mappings
          local options = vim.bo[bufnr].ft == "NvimTree" and "nvimtree" or "default"
          vim.keymap.set("n", "<C-t>", function()
            require("menu").open(options)
          end, opts "Context Menu")
        end,
      }
    end,
  },

  -- menu (Context menu)
  {
    "nvzone/menu",
    lazy = true,
  },

  -- nvim-cmp (Autocompletion)
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return require "configs.cmp"
    end,
  },

  -- nvim-lspconfig (Language Server Protocol)
  {
    "neovim/nvim-lspconfig",
    dependencies = {},
    config = function()
      require "configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- oil.nvim (Nvim Filesystem Explorer and Editor)
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

  -- nvim-repeat
  {
    "tpope/vim-repeat",
    lazy = false,
  },

  -- speeddating (Increment dates)
  {
    "tpope/vim-speeddating",
    lazy = false,
  },

  -- auto-session (Automatically save and restore sessions)
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
          previewer = false,
          mappings = {
            -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
            delete_session = { "i", "<C-D>" },
            alternate_session = { "i", "<C-S>" },
            copy_session = { "i", "<C-Y>" },
          },
          theme_conf = {
            border = true,
          },
        },
      }
    end,
  },

  -- glow (prettier markdown preview; actually not really convincing)
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
  },

  -- diffview
  {
    "sindrets/diffview.nvim",
    command = "DiffviewOpen",
    cond = is_git_root,
    keys = {
      {
        "<leader>gd",
        function()
          require("utils").toggle_diffview "DiffviewOpen"
        end,
        desc = "Diff Index",
      },
      {
        "<leader>gD",
        function()
          require("utils").toggle_diffview "DiffviewOpen master..HEAD"
        end,
        desc = "Diff master",
      },
      {
        "<leader>gf",
        function()
          require("utils").toggle_diffview "DiffviewFileHistory %"
        end,
        desc = "Open diffs for current File",
      },
    },
  },

  -- neogit (Git integration)
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

  -- dashboard (Start screen when starting nvim without arguments)
  {
    "nvimdev/dashboard-nvim",
    lazy = false,
    event = "VimEnter",
    config = function()
      require("dashboard").setup {
        config = {
          week_header = {
            enable = true,
          },
          shortcut = {
            { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
            {
              desc = " Files",
              group = "Label",
              action = 'require("fzf-lua").files()',
              key = "f",
            },
            {
              desc = " Obsidian",
              group = "DiagnosticHint",
              action = function()
                require("utils").open_or_create_session(os.getenv "O_VAULT_DIR")
              end,
              key = "o",
            },
            {
              desc = " Dotfiles",
              group = "Number",
              action = function()
                require("utils").open_or_create_session(os.getenv "HOME" .. "/dotfiles")
              end,
              key = "d",
            },
            {
              desc = " Neovim",
              group = "@string",
              action = "SessionRestore " .. os.getenv "XDG_CONFIG_HOME" .. "/nvim",
              key = "n",
            },
            {
              desc = " Sessions",
              group = "Define",
              action = "SessionSearch",
              key = "s",
            },
          },
          project = {
            enable = true,
            limit = 8,
            action = require("utils").open_or_create_session,
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

  -- nvim-surround (change surrounds of text)
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

  -- nvim-treesitter (Syntax highlighting)
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
    "debugloop/telescope-undo.nvim",
  },

  {
    "nvim-lua/plenary.nvim",
  },

  -- {
  --   "nvim-telescope/telescope-ui-select.nvim",
  -- },

  -- telescope (Fuzzy finder for basically everything. Configured to use fzf)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "andrew-george/telescope-themes",
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
    },
    keys = {
      { -- lazy style key map
        "<leader>u",
        "<cmd>Telescope undo<cr>",
        desc = "undo history",
      },
    },
    opts = {
      extensions_list = { "themes", "fzf" },
      extensions = {
        undo = {
          use_delta = true,
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
            prompt_position = "top",
          },
          vim_diff_opts = {
            ctxlen = 16,
          },
          -- mappings = {
          --   i = {
          --     ["<cr>"] = require("telescope-undo.actions").yank_additions,
          --     ["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
          --     ["<C-cr>"] = require("telescope-undo.actions").restore,
          --     -- alternative defaults, for users whose terminals do questionable things with modified <cr>
          --     ["<C-y>"] = require("telescope-undo.actions").yank_deletions,
          --     ["<C-r>"] = require("telescope-undo.actions").restore,
          --   },
          --   n = {
          --     ["y"] = require("telescope-undo.actions").yank_additions,
          --     ["Y"] = require("telescope-undo.actions").yank_deletions,
          --     ["u"] = require("telescope-undo.actions").restore,
          --   },
          -- },
          -- telescope-undo.nvim config, see below
        },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        ["ui-select"] = {
          require("telescope.themes").get_dropdown {
            -- even more opts
          },
        },
      },
    },
    config = function(_, opts)
      -- load extension
      local telescope = require "telescope"
      telescope.load_extension "themes"
      -- telescope.load_extension "ui-select"
      telescope.setup(opts)
      telescope.load_extension "undo"
    end,
  },

  -- telescope-fzf-native (Faster fzf for telescope)
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  -- actions-preview (code actions and autofixes)
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

  -- nvim-bqf (Better quickfix)
  {
    "kevinhwang91/nvim-bqf",
    lazy = false,
    config = function()
      require("bqf").setup {
        auto_enable = true,
      }
    end,
  },

  -- better-escape
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  -- vimtex (LaTeX support)
  {
    "lervag/vimtex",
    lazy = false, -- we don't want to lazy load VimTeX
    init = function()
      vim.g.vimtex_view_method = "skim"
      vim.g.vimtex_view_skim_sync = 1
      vim.g.vimtex_view_skim_activate = 1
      vim.g.vimtex_syntax_enabled = 1
      -- vim.g.vimtex_view_general_options = "--synctex-forward=@line:@col:@pdf"
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
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape",
        },
      }

      -- Use init for configuration, don't use the more common "config".
    end,
  },

  -- fzf-lua (Fuzzy finder; I like fzf syntax)
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

  -- volt (nvchad pretty interactive UIs; used in minty, menu, ...)
  {
    "nvzone/volt",
    lazy = true,
  },

  -- minty (nvchad pretty colorpicker)
  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },

  -- github copilot (AI code completion)
  {
    "github/copilot.vim",
    lazy = false,
  },

  -- noice (pretty cmdline and messages)
  -- {
  --   "folke/noice.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     lsp = {
  --       signature = {
  --         enabled = true,
  --       },
  --       override = {
  --         ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --         ["vim.lsp.util.stylize_markdown"] = true,
  --         ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
  --       },
  --     },
  --     presets = {
  --       lsp_doc_border = true,
  --     },
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     -- "rcarriga/nvim-notify",
  --   },
  -- },

  -- {
  --   "rcarriga/nvim-notify",
  --   config = function()
  --     local notify = require "notify"
  --     notify.setup {
  --       background_colour = "#181825",
  --     }
  --   end,
  -- },

  -- vim-tmux-navigator (Navigate between vim and tmux panes)
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },

  -- puppeteer (Convert to f-string and back)
  {
    "chrisgrieser/nvim-puppeteer",
    lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
  },
}
