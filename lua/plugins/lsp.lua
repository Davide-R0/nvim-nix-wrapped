return {
  -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',

  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    {
      'williamboman/mason.nvim',
      -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
      -- because we will be using nix to download things instead.
      enabled = require('nixCatsUtils').lazyAdd(true, false),
      config = true,
    }, -- NOTE: Must be loaded before dependants
    {
      'williamboman/mason-lspconfig.nvim',
      -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
      -- because we will be using nix to download things instead.
      enabled = require('nixCatsUtils').lazyAdd(true, false),
    },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- NOTE: nixCats: use lazyAdd to only enable mason if nix wasnt involved.
      -- because we will be using nix to download things instead.
      enabled = require('nixCatsUtils').lazyAdd(true, false),
    },

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    {
      'folke/lazydev.nvim', -- lazydev is the new version of neodev
      ft = 'lua',
      opts = {
        library = {
          -- adds type hints for nixCats global
          { path = (nixCats.nixCatsPath or '') .. '/lua', words = { 'nixCats' } },
        },
      },
    },
  },

  config = function()
    vim.diagnostic.config({
      signs = {
        text = { 
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
        -- Opzionale: map per le priorità o per le linee, ma 'text' è quello che ti serve
      },
      virtual_text = {
        prefix = '●', -- O '■', o quello che preferisci
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

    -- Autocommand per quando l'LSP si aggancia al buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Mappings standard (Telescope integrato)
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror') -- error
        --map('gl', vim.diagnostic.open_float, 'Show diagnostic line')  
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Highlight references
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

        -- Inlay Hints
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Capabilities di base
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- CONFIGURAZIONE SERVER
    local servers = {}

    -- 1. Nix Setup
    if require('nixCatsUtils').isNixCats then
      servers.nixd = {}
    else
      servers.rnix = {}
      servers.nil_ls = {}
    end

    -- Lua
    servers.lua_ls = {
      capabilities = capabilities,
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          diagnostics = { globals = { 'nixCats', 'vim' }, disable = { 'missing-fields' } },
        },
      },
    }

    -- HTML (Configurazione Speciale)
    -- Creiamo capability specifica per snippet html
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

    -- 4. Clangd (C/C++)
    servers.clangd = {
      capabilities = capabilities,
    }

    -- Haskel
    servers.hls = {
      capabilities = capabilities,
    }

    -- OpenSCAD

    -- 5. Rust
    servers.rust_analyzer = {
      capabilities = capabilities,
      settings = {
        ['rust-analyzer'] = {
           cargo = {
             -- SU NIXOS: Generalmente meglio non hardcodare il path se usi nix shell o devShells.
           }
         }
       }
    }

    -- 6. TexLab (LaTeX)
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



--    -- 2. LTeX per la grammatica
--    servers.ltex = {
--      capabilities = capabilities,
--      -- Aggiungi questo flag per dire a lspconfig che ltex-ls supporta i file gitcommit e markdown
--      filetypes = { "markdown", "tex", "bib", "latex", "text", "gitcommit" },
--
--      on_attach = function(client, bufnr)
--        -- 2. Caricamento PROTETTO di ltex_extra
--        -- Se Nix non lo ha caricato, 'ok' sarà false e non crasherà tutto
--        local ok, ltex_extra = pcall(require, "ltex_extra")
--
--        if ok then
--          ltex_extra.setup {
--            load_langs = { "it-IT", "en-US" },
--            init_check = true,
--            -- 3. Passiamo la stringa, NON la funzione
--            path = dict_path,
--            log_level = "trace",
--            server_opts = nil -- Corretto, lasciamo che lspconfig gestisca il server
--          }
--        else
--          vim.notify("ltex_extra non trovato! Verifica il flake.nix", vim.log.levels.WARN)
--        end
--      end,
--      settings = {
--        ltex = {
--          language = "it-IT",
--          --language = "auto",
--          --diagnosticSeverity = "information",
--          additionalRules = {
--            enablePickyRules = true,
--            motherTongue = "it",
--          },
--          disabledRules = {
--            --it = { "APOS_TYP", "FRENCH_WHITESPACE" } 
--          },
--        }
--      }
--    }

    local harper_dict = vim.fn.stdpath("config") .. "/dict/harper_user.txt"
    local dict_dir = vim.fn.stdpath("config") .. "/dict"
    if vim.fn.isdirectory(dict_dir) == 0 then
      vim.fn.mkdir(dict_dir, "p")
    end
    if vim.fn.filereadable(harper_dict) == 0 then
      io.open(harper_dict, "a"):close()
    end
    --servers.harper_ls = {
    --  capabilities = capabilities,
    --  --filetypes = { "markdown", "tex", "bib", "latex", "text", "gitcommit" },
    --  settings = {
    --    ["harper-ls"] = {
    --      userDictPath = harper_dict, --"~/.config/nvim/dict/harper.txt",
    --      -- Impostazioni Linguistiche
    --      -- Harper prova a indovinare la lingua, ma puoi isolarlo
    --      --iso639_1 = "it", -- Forza italiano come lingua principale (opzionale)

    --      linters = {
    --        SpellCheck = true,
    --        SpelledNumbers = false,
    --        AnA = true,-- Ti avvisa se usi parole troppo vecchie (in inglese)
    --        SentenceCapitalization = true,
    --        UnclosedQuotes = true,
    --        WrongQuotes = false,
    --        LongSentences = true,
    --        RepeatedWords = true,
    --        Spaces = true,
    --        Matcher = true,
    --        CorrectNumberSuffix = true
    --      },

    --      -- Code Actions
    --      codeActions = {
    --        ForceStable = true, -- Stabilizza i suggerimenti
    --      },
    --      markdown = {
    --        ignoredLintsPath = true,
    --        IgnoreLinkTitle = true,
    --      },
    --      diagnosticSeverity = "hint",
    --      --isolateEnglish = false, --??
    --      --dialect = "American",
    --      maxFileLength = 120000,
    --      ignoredLintsPath = "",
    --      excludePatterns = {}
    --    }
    --  }
    --};

    -- Markdown oxide
    servers.markdown_oxide = {
      capabilities = vim.tbl_deep_extend('force', capabilities, {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          }
        }
      ),
    }

    -- Lean
    servers.leanls = {
      -- Riusiamo le capabilities standard (completamento cmp)
      capabilities = capabilities,
      -- Le opzioni che prima erano dentro 'lean.setup { lsp = { init_options = ... } }'
      init_options = {
        editDelay = 1000,
        hasWidgets = true,
      }
    }

    -- Taplo (toml/json)
    servers.taplo = {
      capabilities = capabilities,
      settings = {
        evenBetterToml = {
          schema = {
            -- Permette di scaricare automaticamente gli schemi (es. per GitHub workflows, Cargo, ecc.)
            enable = true,
          }
        }
      }
    }

    -- Bash
    servers.bashls = {
      capabilities = capabilities,
    }

    -- Cmake
    servers.cmake = {
      capabilities = capabilities,
    }

    -- OpenSCAD 
    servers.openscad_lsp = {
      capabilities = capabilities,
    }

    --servers.arduino_language_server = {}
    servers.asm_lsp = {
      capabilities = capabilities,
    }

    servers.basedpyright = {
      capabilities = capabilities,
    }

    servers.ts_ls = {
      capabilities = capabilities,
    }


    -- LOGICA DI CARICAMENTO (NixCats vs Mason)
    if require('nixCatsUtils').isNixCats then
      for server_name, cfg in pairs(servers) do
        -- Applica capabilities globali se non sovrascritte
        cfg.capabilities = vim.tbl_deep_extend('force', capabilities, cfg.capabilities or {})
        vim.lsp.config(server_name, cfg)
        vim.lsp.enable(server_name)
      end
    else
      -- Logica Mason (Fallback per non-Nix)
      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, { 'stylua' })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local cfg = servers[server_name] or {}
            cfg.capabilities = vim.tbl_deep_extend('force', capabilities, cfg.capabilities or {})
            vim.lsp.config(server_name, cfg)
            vim.lsp.enable(server_name)
          end,
        },
      }
    end
  end,
}
