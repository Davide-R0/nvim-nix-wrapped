return {
  {
    "nvim-lspconfig",
    auto_enable = true,
    after = function()
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
          source = "always",
          header = "Diagnostic:",
          prefix = ' ● ',
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {}

      servers.nixd = {}

      servers.lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = { callSnippet = 'Replace' },
            diagnostics = { globals = { 'vim' }, disable = { 'missing-fields' } },
          },
        },
      }

      local html_capabilities = vim.tbl_deep_extend('force', capabilities, {
        textDocument = { completion = { completionItem = { snippetSupport = true } } }
      })
      servers.html = {
        capabilities = html_capabilities,
        cmd = { "vscode-html-language-server", "--stdio" },
        filetypes = { "html", "templ" },
        init_options = {
          configurationSection = { "html", "css", "javascript" },
          embeddedLanguages = { css = true, javascript = true },
          provideFormatter = true
        }
      }

      servers.clangd = { capabilities = capabilities }
      servers.hls = { capabilities = capabilities }

      servers.rust_analyzer = {
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            cargo = {}
          }
        }
      }

      servers.texlab = {
        capabilities = capabilities,
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

      servers.tinymist = {
        capabilities = capabilities,
        cmd = { "tinymist" },
        settings = {
          exportPdf = "onSave",
          formatterMode = "typstyle",
          exportHtml = "never",
        }
      };

      local harper_dict = vim.fn.stdpath("config") .. "/dict/harper_user.txt"
      local dict_dir = vim.fn.stdpath("config") .. "/dict"
      if vim.fn.isdirectory(dict_dir) == 0 then
        vim.fn.mkdir(dict_dir, "p")
      end
      if vim.fn.filereadable(harper_dict) == 0 then
        io.open(harper_dict, "a"):close()
      end

      servers.markdown_oxide = {
        capabilities = vim.tbl_deep_extend('force', capabilities, {
          workspace = {
            didChangeWatchedFiles = { dynamicRegistration = true },
          }
        }),
      }

      servers.leanls = {
        capabilities = capabilities,
        init_options = {
          editDelay = 1000,
          hasWidgets = true,
        }
      }

      servers.taplo = {
        capabilities = capabilities,
        settings = {
          evenBetterToml = { schema = { enable = true } }
        }
      }

      servers.bashls = { capabilities = capabilities }
      servers.cmake = { capabilities = capabilities }
      servers.openscad_lsp = { capabilities = capabilities }
      servers.asm_lsp = { capabilities = capabilities }
      servers.basedpyright = { capabilities = capabilities }
      servers.ts_ls = { capabilities = capabilities }

      for server_name, cfg in pairs(servers) do
        cfg.capabilities = vim.tbl_deep_extend('force', capabilities, cfg.capabilities or {})
        vim.lsp.config(server_name, cfg)
        vim.lsp.enable(server_name)
      end
    end,
  }
}
