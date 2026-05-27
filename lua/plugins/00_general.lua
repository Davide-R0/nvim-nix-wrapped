return {
  {
    "typst-preview.nvim",
    auto_enable = true,
    ft = 'typst',
    version = '1.*',
    opts = {},
  },
  {
    "calendar.vim",
    auto_enable = true,
    after = function()
      -- Configurazione opzionale: inizia la settimana di lunedì
      vim.g.calendar_monday = 1
    end
  },
  {
    "conform.nvim",
    auto_enable = true,
    opts = function()
      local md_line_length = 80 
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
    "fzf.vim",
    auto_enable = true,
    dep_of = { "openscad.nvim" },
    after = function()
    end,
  },
  {
    "openscad.nvim",
    auto_enable = true,
    after = function()
      vim.g.openscad_load_snippets = true
      require("openscad")
    end,
  },
  {
    "luasnip",
    auto_enable = true,
    dep_of = { "openscad.nvim" }
  },
  {
    "actions-preview.nvim",
    auto_enable = true,
    after = function()
      vim.keymap.set({ "v", "n" }, '<leader>ca', require("actions-preview").code_actions)
    end,
  },
  {
    "nvim-colorizer.lua",
    auto_enable = true,
    enabled = true,
    opts = {},
  },
  {
    "csvview.nvim",
    auto_enable = true,
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
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  {
    "vim-table-mode",
    auto_enable = true,
    ft = { "markdown", "pandoc" },
    cmd = { "TableModeToggle", "TableModeEnable" },
    before = function()
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_header_fillchar = "-"
      vim.g.table_mode_disable_mappings = 1
    end,
    after = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("TableModeEnable")
        end,
      })
    end,
  },
  {
    "cornelis",
    auto_enable = true,
    ft = 'agda',
    version = '*',
    after = function()
      vim.g.cornelis_use_global_binary = 1 
    end,
  },
  {
    "nvim-hs.vim",
    auto_enable = true,
    dep_of = { "cornelis" }
  },
  {
    "vim-textobj-user",
    auto_enable = true,
    dep_of = { "cornelis" }
  },
  {
    "markdown-preview.nvim",
    auto_enable = true,
    for_cat = 'markdown',
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle", },
    ft = "markdown",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview <CR>",       mode = { "n" }, noremap = true, desc = "markdown preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop <CR>",   mode = { "n" }, noremap = true, desc = "markdown preview stop" },
      { "<leader>mt", "<cmd>MarkdownPreviewToggle <CR>", mode = { "n" }, noremap = true, desc = "markdown preview toggle" },
    },
    before = function(plugin)
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    "todo-comments.nvim",
    auto_enable = true,
    event = 'VimEnter',
    opts = { signs = false }
  },
  {
    "plenary.nvim",
    auto_enable = true,
    dep_of = { "todo-comments.nvim", "lazygit.nvim" }
  },
  {
    "fidget.nvim",
    auto_enable = true,
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
    auto_enable = true,
    ft = 'lua',
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "popup.nvim",
    auto_enable = true,
    enable = true,
    event = "DeferredUIEnter",
  },
  {
    "nvim-spectre",
    auto_enable = true,
    enable = true,
    event = "DeferredUIEnter",
  },
  {
    "undotree",
    auto_enable = true,
    enable = true,
    event = "DeferredUIEnter",
  },
  {
    "gitsigns.nvim",
    auto_enable = true,
    event = "BufReadPre",
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
    auto_enable = true,
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile", },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    "diffview.nvim",
    auto_enable = true,
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diff View Open" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>",         desc = "Diff View Close" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { default = { layout = "diff2_horizontal" } }
    }
  },
  {
    "vim-fugitive",
    auto_enable = true,
    cmd = { "G", "Git" },
    keys = {
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
    }
  },
  {
    "crates.nvim",
    auto_enable = true,
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        completion = true,
        actions = true,
        hover = true,
        on_attach = function(client, bufnr)
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
