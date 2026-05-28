return {
  {
    "nvim-lspconfig",

    enabled = true,
    auto_enable = true,
    lazy = false,

    dep_of = { "lean.nvim" },

    lsp = function(plugin)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local config = vim.tbl_deep_extend('force', {
        capabilities = capabilities,
      }, plugin.lsp or {})

      vim.lsp.config(plugin.name, config)
      vim.lsp.enable(plugin.name)
    end,

    before = function(_)
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
        on_attach = function(_, bufnr)
          -- we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
          end

          nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
          nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
          nmap('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror')
          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- Lesser used LSP functionality
          --nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist Folders')

          -- Create a command `:Format` local to the LSP buffer
          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format()
          end, { desc = 'Format current buffer with LSP' })

          -- highlight cursore
          local client = vim.lsp.get_client_by_id(_)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' },
              {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' },
              {
                buffer = bufnr,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })
          end
        end
      })
    end,

    -- questo metodo sembra non funzionare...
    --vim.api.nvim_create_autocmd('LspAttach', {
    --  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    --  callback = function(event)
    --    local map = function(keys, func, desc)
    --      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    --    end

    --    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    --    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    --    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    --    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    --    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    --    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    --    map('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror')
    --    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    --    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    --    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    --    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    --    local client = vim.lsp.get_client_by_id(event.data.client_id)
    --    if client and client.server_capabilities.documentHighlightProvider then
    --      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
    --      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    --        buffer = event.buf,
    --        group = highlight_augroup,
    --        callback = vim.lsp.buf.document_highlight,
    --      })
    --      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    --        buffer = event.buf,
    --        group = highlight_augroup,
    --        callback = vim.lsp.buf.clear_references,
    --      })
    --      vim.api.nvim_create_autocmd('LspDetach', {
    --        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
    --        callback = function(event2)
    --          vim.lsp.buf.clear_references()
    --          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
    --        end,
    --      })
    --    end

    --    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
    --      map('<leader>th', function()
    --        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    --      end, '[T]oggle Inlay [H]ints')
    --    end
    --  end,
    --})
  },

  {
    "nixd",

    --for_cat = "nix",
    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "nix" },
    lsp = {}
  },

  {
    "lua_ls",

    --for_cat = "lua",
    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "lua" },
    lsp = {
      settings = {
        Lua = {
          signatureHelp = { enabled = true },
          completion = { callSnippet = 'Replace' },
          diagnostics = {
            globals = { "nixInfo", "vim", },
            disable = { 'missing-fields' },
          },
        },
      },
    },
  },

  {
    "html",

    enabled = true,
    auto_enable = true,
    lazy = true,

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

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "c", "cpp" },
    lsp = {}
  },
  {
    "hls",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "haskell" },
    lsp = {}
  },

  {
    "rust_analyzer",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "rust" },
    lsp = {
      settings = {
        ['rust-analyzer'] = { cargo = {} }
      }
    }
  },

  {
    "texlab",

    enabled = true,
    auto_enable = true,
    lazy = true,

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

    enabled = true,
    auto_enable = true,
    lazy = true,

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

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "markdown" },
    lsp = {}
  },

  {
    "leanls",

    enabled = true,
    auto_enable = true,
    lazy = true,

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

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "toml" },
    lsp = {
      settings = {
        evenBetterToml = { schema = { enable = true } }
      }
    }
  },

  {
    "bashls",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "sh" },
    lsp = {}
  },
  {
    "cmake",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "cmake" },
    lsp = {}
  },
  {
    "openscad_lsp",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "openscad" },
    lsp = {}
  },
  {
    "asm_lsp",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "asm", "s", "S" },
    lsp = {}
  },
  {
    "basedpyright",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "python" },
    lsp = {}
  },
  {
    "ts_ls",

    enabled = true,
    auto_enable = true,
    lazy = true,

    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    lsp = {}
  },
}
