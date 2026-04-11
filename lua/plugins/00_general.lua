return {
  --{ -- idris 2
  --  'ShinKage/idris2-nvim',
  --  dependencies = {'neovim/nvim-lspconfig', 'MunifTanjim/nui.nvim'},
  --  config = function()
  --    require('idris2').setup({ })
  --  end
  --},

  -- Typst preview
  {
    'chomosuke/typst-preview.nvim',
    --lazy = false, -- or
    ft = 'typst',
    version = '1.*',
    opts = {},
  },

  {
    "itchyny/calendar.vim",
    config = function()
      -- Configurazione opzionale: inizia la settimana di lunedì
      vim.g.calendar_monday = 1
    end
  },

  {
    "nvim-neorg/neorg",
    lazy = false,  -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release

    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-neorg/neorg-telescope" },
    },

    opts = {
      load = {
        ["core.defaults"] = {},      -- Carica tutte le funzionalità base vitali

        ["core.esupports.hop"] = {}, -- Abilita il salto tra i link

        ["core.concealer"] = {
          config = {
            -- Questo modulo è quello che trasforma i caratteri grezzi in bellissime icone
            icon_preset = "varied",
          },
        },

        --        ["core.integrations.calendar"] = {},

        ["core.dirman"] = { -- Il "Directory Manager": gestisce i tuoi workspace
          config = {
            workspaces = {
              -- Puoi mettere i percorsi che preferisci
              --lavoro = "~/note_lavoro",
              personale = "~/Norg",
              --progetti = "~/Documenti/progetti_norg",
            },
            -- Opzionale: quale workspace aprire di default
            default_workspace = "personale",
          },
        },

        ["core.integrations.nvim-cmp"] = {},

        ["core.integrations.telescope"] = {},

        ["core.journal"] = {
          config = {
            workspace = "personale", -- In quale workspace mettere le note del giorno
          },
        },

        ["core.tangle"] = {
          config = { tangle_on_write = true }
        },

      },
    },
  },


  --'conform.nvim'
  {
    "stevearc/conform.nvim",
    -- TODO: passare a markdown-lint2: markdown = { "markdownlint-cli2" },

    opts = function()
      -- Leggi il valore da Nix. Se non esiste, usa 80 come fallback.
      local md_line_length = nixCats('settings.categories.markdown-line-length') or 80 -- NON FUNZIONA!!

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
    --[[
    opts = {
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
    },]] --
    -- note sulla formattazione per progetto:
    -- avere un file .edirotconfig nella root del progetto con ad esempio:
    --[[
      root = true

      [*]
      end_of_line = lf
      insert_final_newline = true
      charset = utf-8
      trim_trailing_whitespace = true
      indent_style = space
      indent_size = 2
      max_line_length = 80

      [*.md]
      indent_size = 2
      max_line_length = 80
    --]]
    -- e per il markdown specifico usare un file sempre nella root `.markdownlint.json`:
    --[[
      {
        "MD004": { "style": "dash" },
        "MD007": { "indent": 2 },
        "MD013": {
          "line_length": 80,
          "code_blocks": false,
          "tables": false,
          "headings": false,
          "strict": true
        },
        "MD001": true,
        "MD041": false
      }
    --]]
  },

  {
    "junegunn/fzf.vim",
    config = function()
    end,
  },

  { -- OpenSCAD plugin
    "salkin-mada/openscad.nvim",
    config = function()
      vim.g.openscad_load_snippets = true
      require("openscad")
    end,
    dependencies = { "L3MON4D3/LuaSnip", "junegunn/fzf.vim" },
  },

  --(Do not work)
  --{
  --  'xzbdmw/colorful-menu.nvim',
  --  on_plugin = { "nvim-cmp" },
  --},
  { -- Code actions
    "aznhe21/actions-preview.nvim",
    config = function()
      vim.keymap.set({ "v", "n" }, '<leader>ca', require("actions-preview").code_actions)
    end,
  },

  -- Colors in #ffffff
  {
    'norcalli/nvim-colorizer.lua',
    enabled = true,
    opts = {},
  },

  { -- csv viewer
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },

  {                                                 -- Md table alignment
    "dhruvasagar/vim-table-mode",
    ft = { "markdown", "pandoc" },                  -- Carica il plugin solo per i file Markdown (ottimizzazione Lazy)
    cmd = { "TableModeToggle", "TableModeEnable" }, -- Oppure caricalo quando lanci il comando
    init = function()
      -- Imposta il carattere degli angoli a '|' invece che '+'
      vim.g.table_mode_corner = "|"
      -- Opzionale: Per avere bordi compatibili con GFM (GitHub Flavored Markdown)
      vim.g.table_mode_corner_corner = "|"
      vim.g.table_mode_header_fillchar = "-"
      -- Opzionale: Disabilita i mapping di default se vanno in conflitto
      vim.g.table_mode_disable_mappings = 1 -- Usare in command mode
    end,

    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("TableModeEnable")
        end,
      })
    end,
  },

  -- Agda
  {
    'isovector/cornelis',
    name = 'cornelis',
    ft = 'agda',
    --build = 'stack install',
    build = "stack build",
    dependencies = { 'neovimhaskell/nvim-hs.vim', 'kana/vim-textobj-user' },
    version = '*',
    config = function()
      -- Configurazione base
      vim.g.cornelis_use_global_binary = 1 -- Importante: usa il cornelis installato da Nix!
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    -- NOTE: for_cat is a custom handler that just sets enabled value for us,
    -- based on result of nixCats('cat.name') and allows us to set a different default if we wish
    -- it is defined in luaUtils template in lua/nixCatsUtils/lzUtils.lua
    -- you could replace this with enabled = nixCats('cat.name') == true
    -- if you didnt care to set a different default for when not using nix than the default you already set
    lazy = true,
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

  { -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },

  { -- for notifications
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        }
      },
    },
  },

  { -- For lua nvim config lsp
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Carica i tipi per l'API di Neovim (risolve il problema 'vim')
        { path = "luvit-meta/library",                  words = { "vim%.uv" } },
        -- adds type hints for nixCats global
        { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
      },
    },
  },

  { --for some funtionalities of popup windows
    'nvim-lua/popup.nvim',
    enable = true,
    lazy = false,
  },

  { -- fuzzi finder
    'nvim-pack/nvim-spectre',
    enable = true,
    lazy = false,
  },

  {
    'mbbill/undotree',
    enable = true,
    lazy = false,
  },

  -- Git
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
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
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile", },
    -- Opzionale: per caricare l'interfaccia dello stato di git su telescope
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- Premi <leader>gg per aprire la dashboard di Git
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      -- Apre la vista diff per tutti i file modificati
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diff View Open" },
      -- Chiude la vista diff
      { "<leader>gc", "<cmd>DiffviewClose<cr>",         desc = "Diff View Close" },
      -- Mostra la storia delle modifiche del file corrente
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = { default = { layout = "diff2_horizontal" } }
    }
  },

  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git" },
    keys = {
      -- Ottimo per vedere chi ha scritto quella riga (Git Blame) in una finestra a lato
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git Blame" },
    }
  },

  -- Cargo toml files
  {
    "saecki/crates.nvim",
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
          -- Per scorrere si usano i tasti standard di vim (j/k)
        },
      },
    },
  }

}
