return {
  {
    "nvim-lspconfig",
    enabled = true,
    auto_enable = true,
    lazy = false,
    dep_of = { "lean.nvim" },

    lsp = function(plugin)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
      if ok_cmp then
        capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
      end

      local config = vim.tbl_deep_extend('force', {
        capabilities = capabilities,
      }, plugin.lsp or {})

      vim.lsp.config(plugin.name, config)
      vim.lsp.enable(plugin.name)
    end,

    before = function()
      -- Configurazione grafica della diagnostica
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        virtual_text = {
          prefix = '●',
        },
        float = {
          border = "rounded",
          source = true,
          header = "Diagnostic:",
          prefix = ' ● ',
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.lsp.config('*', {
        on_attach = function(client, bufnr)
          -- Funzione helper per definire scorciatoie
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end

          nmap('gd', '<cmd>Telescope lsp_definitions<CR>', '[G]oto [D]efinition')
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('gr', '<cmd>Telescope lsp_references<CR>', '[G]oto [R]eferences')
          nmap('gI', '<cmd>Telescope lsp_implementations<CR>', '[G]oto [I]mplementation')
          nmap('<leader>D', '<cmd>Telescope lsp_type_definitions<CR>', 'Type [D]efinition')
          nmap('<leader>ds', '<cmd>Telescope lsp_document_symbols<CR>', '[D]ocument [S]ymbols')
          nmap('<leader>ws', '<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', '[W]orkspace [S]ymbols')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror')
          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          -- Comando :Format locale al buffer
          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })

          -- Highlight del cursore se supportato dal server LSP
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = bufnr,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end
      })
    end,
  },

  {
    "nixd",
    ft = { "nix" },
    lsp = {
      settings = {
        nixd = {
          nixpkgs = { expr = [[import <nixpkgs> {}]] },
          formatting = { command = { "nixfmt" } }
        }
      }
    }
  },

  {
    "lua_ls",
    ft = { "lua" },
    lsp = {
      settings = {
        Lua = {
          signatureHelp = { enabled = true },
          completion = { callSnippet = 'Replace' },
          diagnostics = { globals = { "nixInfo", "vim" }, disable = { "missing-fields" } },
        },
      },
    },
  },

  {
    "html",
    ft = { "html", "templ" },
    lsp = {
      cmd = { "vscode-html-language-server", "--stdio" },
      init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = { css = true, javascript = true },
        provideFormatter = true
      }
    }
  },

  {
    "clangd",
    ft = { "c", "cpp" },
    lsp = {}
  },

  {
    "hls",
    ft = { "haskell" },
    lsp = {}
  },

  {
    "rust_analyzer",
    ft = { "rust" },
    lsp = {
      settings = {
        ['rust-analyzer'] = { cargo = {} }
      }
    }
  },

  {
    "texlab",
    ft = { "tex" },
    lsp = {
      settings = {
        texlab = {
          bibtexFormatter = "texlab",
          build = {
            args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
            executable = "latexmk",
            forwardSearchAfter = false,
            onSave = false
          },
          chktex = { onEdit = false, onOpenAndSave = false },
          diagnosticsDelay = 300,
          formatterLineLength = 80,
          forwardSearch = { args = {} },
          latexFormatter = "latexindent",
          latexindent = { modifyLineBreaks = false }
        }
      }
    }
  },

  {
    "tinymist",
    ft = { "typst" },
    lsp = {
      cmd = { "tinymist" },
      settings = {
        exportPdf = "onSave",
        formatterMode = "typstyle",
        exportHtml = "never",
      }
    }
  },

  {
    "markdown_oxide",
    ft = { "markdown" },
    lsp = {}
  },

  {
    "leanls",
    ft = { "lean" },
    lsp = {
      init_options = {
        editDelay = 1000,
        hasWidgets = true,
      }
    }
  },

  {
    "taplo",
    ft = { "toml" },
    lsp = {
      settings = {
        evenBetterToml = { schema = { enable = true } }
      }
    }
  },

  {
    "bashls",
    ft = { "sh" },
    lsp = {}
  },

  {
    "cmake",
    ft = { "cmake" },
    lsp = {}
  },

  {
    "openscad_lsp",
    ft = { "openscad" },
    lsp = {}
  },

  {
    "asm_lsp",
    ft = { "asm", "s", "S" },
    lsp = {}
  },

  {
    "basedpyright",
    ft = { "python" },
    lsp = {}
  },

  {
    "ts_ls",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    lsp = {}
  },
}
