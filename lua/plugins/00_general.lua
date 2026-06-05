return {
  {
    "nvim-web-devicons",

    enabled = vim.g.have_nerd_font,
    auto_enable = true,
    lazy = true,

    dep_of = { "alpha-nvim", "oil.nvim", "telescope.nvim", "lualine.nvim", "render-markdown.nvim" }
  },
  {
    "typst-preview.nvim",

    enabled = true,
    auto_enable = false,

    ft = 'typst',
    version = '1.*',

    after = function(plugin)
      require("typst-preview").setup(plugin.opts)
    end,
    opts = {},
  },
  {
    "calendar.vim",

    enabled = true,
    auto_enable = true, -- WARN : non dovrebbe esser false
    lazy = true,

    cmd = { "Calendar" },

    after = function()
      vim.g.calendar_monday = 1
    end
  },
  {
    "conform.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    event = { "BufWritePre" },

    after = function(plugin)
      local opts = plugin.opts
      if type(opts) == "function" then
        opts = opts()
      end
      require("conform").setup(opts)
    end,
    opts = function()
      local md_line_length = nixInfo(80, "settings", "conform", "md_line_length")

      return {
        formatters_by_ft = {
          markdown = { "prettier", "markdownlint-cli2" },
        },
        formatters = {
          prettier = {
            prepend_args = { "--print-width", tostring(md_line_length), "--prose-wrap", "always" },
          },
        },
        format_on_save = {
          timeout_ms = 3500,
          lsp_fallback = true,
        },
      }
    end,
  },
  {
    "nvim-autopairs",

    enabled = true,
    auto_enable = false,
    lazy = true,

    event = { "InsertEnter" },

    after = function()
      require('nvim-autopairs').setup {}
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "fzf.vim",

    enabled = true,
    auto_enable = true,
    lazy = true,

    dep_of = { "openscad.nvim" }, -- TODO: forse servve anche ad lualine?

    after = function()
    end,
  },
  {
    "openscad.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    ft = { "openscad" },

    after = function()
      vim.g.openscad_load_snippets = true
      require("openscad")
    end,
  },
  {
    "luasnip",

    enabled = true,
    auto_enable = true,
    lazy = true,

    dep_of = { "nvim-cmp", "openscad.nvim" }
  },
  {
    "actions-preview.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    dep_of = { "telescope.nvim" },
    keys = {
      { "<leader>ca", function() require("actions-preview").code_actions() end, mode = { "v", "n" }, desc = "Code Actions Preview" },
    },
  },
  {
    "nvim-colorizer.lua",

    enabled = true,
    auto_enable = false,
    lazy = true,

    event = { "BufReadPost", "BufEnter" },

    after = function(plugin)
      require("colorizer").setup(plugin.opts)
    end,
    opts = {},
  },
  {
    "csvview.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },

    after = function(plugin)
      require("csvview").setup(plugin.opts)
    end,
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
  },
  --{
  --  "vim-table-mode",

  --  enabled = true,
  --  auto_enable = true,
  --  lazy = true,

  --  ft = { "markdown", "pandoc" },
  --  cmd = { "TableModeToggle", "TableModeEnable" },

  --  before = function()
  --    vim.g.table_mode_corner = "|"
  --    vim.g.table_mode_corner_corner = "|"
  --    vim.g.table_mode_header_fillchar = "-"
  --    vim.g.table_mode_disable_mappings = 1
  --    --end,
  --    --after = function()
  --    vim.api.nvim_create_autocmd("FileType", {
  --      pattern = "markdown",
  --      callback = function()
  --        vim.cmd("TableModeEnable")
  --      end,
  --    })
  --  end,
  --},
  {
    "cornelis",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = 'agda',
    version = '*',
    after = function()
      vim.g.cornelis_use_global_binary = 1
    end,
  },
  {
    "nvim-hs.vim",
    enabled = true,
    auto_enable = true,
    lazy = true,

    dep_of = { "cornelis" }
  },
  {
    "vim-textobj-user",

    enabled = true,
    auto_enable = true,
    lazy = true,

    dep_of = { "cornelis" }
  },
  {
    "todo-comments.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    event = 'BufReadPost',

    after = function(plugin)
      require("todo-comments").setup(plugin.opts)
    end,
    opts = {
      --signs = false,

      colors = {
        error   = { "DiagnosticError", "ErrorMsg", "#DC2626" },  -- Rosso
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" }, -- Giallo
        info    = { "DiagnosticInfo", "#2563EB" },               -- Blu
        hint    = { "DiagnosticHint", "#10B981" },               -- Verde
        default = { "Identifier", "#7C3AED" },                   -- Viola
        my_todo = { "#FF00FF" }                                  -- Fucsia (Esempio personalizzato!)
      },

      keywords = {
        FIX  = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "my_todo" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "default", alt = { "TESTING", "PASSED", "FAILED" } },
      },
    }
  },
  {
    "plenary.nvim",

    enabled = true,
    auto_enable = true,
    lazy = true,

    dep_of = { "todo-comments.nvim", "lazygit.nvim", "telescope.nvim", "obsidian.nvim", "lean.nvim", "codecompanion.nvim", "neorg" }
  },
  {
    "fidget.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    event = "LspAttach",

    after = function(plugin)
      require("fidget").setup(plugin.opts)
    end,
    opts = {
      notification = {
        window = {
          winblend = 0,
        }
      },
    },
  },
  {
    "lazydev.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    ft = 'lua',

    after = function(plugin)
      require("lazydev").setup(plugin.opts)
    end,
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "popup.nvim",

    enabled = true,
    auto_enable = true,
    lazy = true,

    dep_of = { "telescope.nvim" }
  },
  {
    "nvim-spectre",

    enabled = true,
    auto_enable = true,
    lazy = true,

    cmd = { "Spectre" },
    keys = {
      { "<leader>S",  function() require("spectre").toggle() end,                                 mode = "n", desc = "Toggle Spectre" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end,      mode = "n", desc = "Search current word" },
      { "<leader>sw", function() require("spectre").open_visual() end,                            mode = "v", desc = "Search current word" },
      { "<leader>sp", function() require("spectre").open_file_search({ select_word = true }) end, mode = "n", desc = "Search on current file" }
    }
  },
  {
    "undotree",

    enabled = true,
    auto_enable = true,
    lazy = true,

    cmd = { "UndotreeToggle" },
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", mode = "n", desc = "Toggle UndoTree" }
    }
  },
  {
    "gitsigns.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    event = { "BufReadPre", "BufNewFile" }, -- meglio  "BufReadPre"?

    after = function(plugin)
      require("gitsigns").setup(plugin.opts)
    end,
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    }
  },
  {
    "lazygit.nvim",

    enabled = true,
    auto_enable = true,
    lazy = true,

    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile", },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", mode = "n", desc = "LazyGit" }
    }
  },
  {
    "diffview.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          mode = "n", desc = "Diff View Open" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>",         mode = "n", desc = "Diff View Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", mode = "n", desc = "File History" },
    },

    after = function(plugin)
      require("diffview").setup(plugin.opts)
    end,
    opts = {
      enhanced_diff_hl = true,
      view = { default = { layout = "diff2_horizontal" } }
    }
  },
  {
    "vim-fugitive",

    enabled = true,
    auto_enable = true,
    lazy = true,

    cmd = { "G", "Git" },
    keys = {
      { "<leader>gb", "<cmd>Git blame<cr>", mode = "n", desc = "Git Blame" },
    }
  },
  {
    "crates.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    event = { "BufRead Cargo.toml" },

    after = function(plugin)
      require("crates").setup(plugin.opts)
    end,
    opts = {
      lsp = {
        enabled = true,
        completion = true,
        actions = true,
        hover = true,
        on_attach = function(_, bufnr)
          local crates = require("crates")
          vim.keymap.set("n", "<leader>ch", crates.open_homepage, { buffer = bufnr, desc = "Open Crate Homepage" })
          vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { buffer = bufnr, desc = "Show Crate Versions" })
          vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { buffer = bufnr, desc = "Show Crate Features" })
        end,
      },
      popup = {
        autofocus = true,
        border = "rounded",
        show_version_date = true,
        show_dependency_version = true,
        max_height = 30,
        min_width = 20,
        padding = 1,
        keys = {
          hide = { "q", "<Esc>" },
          select = { "<CR>", "<Space>" },
          copy_value = { "yy" },
        },
      },
    },
  }
}
