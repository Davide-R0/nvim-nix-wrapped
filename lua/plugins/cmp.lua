return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',

  name = 'nvim-cmp',

  event = { 'InsertEnter', 'CmdlineEnter' }, -- load even when enter in comand line

  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      -- NOTE: nixCats: nix downloads it with a different file name.
      -- tell lazy about that.
      name = 'luasnip',
      build = require('nixCatsUtils').lazyAdd((function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)()),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
    },
    'saadparwaiz1/cmp_luasnip',

    -- Adds other completion capabilities.
    --  nvim-cmp does not ship with all sources by default. They are split
    --  into multiple repos for maintenance purposes.
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',  -- Per completamento parole nel buffer
    'hrsh7th/cmp-cmdline', -- Per completamento nella riga di comando (:, /)
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    -- DEFINIZIONE COLORI (Opzionale, per assicurare che il winhighlight funzioni)
    -- vim.api.nvim_set_hl(0, 'CmpNormal', { link = 'Normal' })
    -- vim.api.nvim_set_hl(0, 'FloatBorder', { link = 'Normal' })

    local kind_icons = {
      Text = '',
      Method = '󰆧',
      Function = '󰊕',
      Constructor = '',
      Field = '󰇽',
      Variable = '󰂡',
      Class = '󰠱',
      Interface = '',
      Module = '',
      Property = '󰜢',
      Unit = '',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰏿',
      Struct = '',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '󰅲',
      -- Aggiunta per AI
      CMPAI = '🤖',
    }

    -- FUNZIONE DI FORMATTAZIONE (Grafica menu)
    local format_func = function(entry, vim_item)
      -- A. Gestione Icone Base
      if kind_icons[vim_item.kind] then
        vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
      end

      -- B. Etichetta Sorgente (Menu a destra)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        cmp_ai = '[AI]',
        luasnip = '[Snip]',
        buffer = '[Buf]',
        path = '[Path]',
        cmdline = '', -- Lasciamo vuoto in cmdline per pulizia
      })[entry.source.name]

      -- C. LOGICA SPECIALE PER CMDLINE
      -- Se siamo in cmdline (:) o path, rimuoviamo il "Kind" (es. Variable)
      if entry.source.name == 'cmdline' or entry.source.name == 'path' then
        vim_item.kind = '' -- Rimuove testo e icona
        -- Se vuoi SOLO l'icona ma non il testo 'Variable', usa:
        -- vim_item.kind = kind_icons[vim_item.kind] or ''
      end

      return vim_item
    end

    -- MAPPING COMUNI (Definiti qui per usarli ovunque)
    local function get_mappings(is_cmdline)
      return {
        -- Navigazione stile Telescope/Readline
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), --cmp.SelectBehavior.Select Se non vuoi che mette il testo selezionato nel buffer fino a conferma
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),

        -- Scroll documentazione (come Telescope preview)
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- Conferma (Stile standard Vim/Readline)
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        -- Se vuoi che anche INVIO confermi, ma solo se hai già selezionato qualcosa
        ['<CR>'] = cmp.mapping.confirm({ select = false }),

        -- Annulla (Stile Readline: Exit/Abort)
        ['<C-e>'] = cmp.mapping.abort(),

        -- Trigger manuale
        ['<C-Space>'] = cmp.mapping.complete({}),

        -- -- Navigazione Giù (Ctrl-n o Ctrl-j)
        -- ['<C-n>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then cmp.select_next_item() else fallback() end
        -- end, { 'i', 'c', 's' }),
        -- ['<C-j>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then cmp.select_next_item() else fallback() end
        -- end, { 'i', 'c', 's' }),

        -- -- Navigazione Su (Ctrl-p o Ctrl-k)
        -- ['<C-p>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then cmp.select_prev_item() else fallback() end
        -- end, { 'i', 'c', 's' }),
        -- ['<C-k>'] = cmp.mapping(function(fallback)
        --   if cmp.visible() then cmp.select_prev_item() else fallback() end
        -- end, { 'i', 'c', 's' }),

        -- -- Scroll Docs
        -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-d>'] = cmp.mapping.scroll_docs(4),

        -- -- Conferma
        -- ['<C-y>'] = cmp.mapping.confirm { select = true },
        -- ['<CR>'] = cmp.mapping.confirm { select = false }, -- Enter conferma solo se selezionato esplicitamente

        -- -- Trigger manuale
        -- ['<C-Space>'] = cmp.mapping.complete {},

        -- -- Annulla
        -- ['<C-e>'] = cmp.mapping.abort(),

        -- -- Snippet Jump (solo insert)
        -- ['<C-l>'] = cmp.mapping(function()
        --   if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
        -- end, { 'i', 's' }),
        -- ['<C-h>'] = cmp.mapping(function()
        --   if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
        -- end, { 'i', 's' }),
      }
    end

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      --completion = { completeopt = 'menu,menuone,noinsert' },

      -- GRAFICA FINESTRE (Bordi arrotondati)
      window = {
        completion = {
          border = 'rounded',
          scrollbar = true,
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          border = 'rounded',
          winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
        }
      },

      -- MAPPINGS GENERALI
      mapping = cmp.mapping.preset.insert(get_mappings(false)),

      -- SORGENTI
      sources = cmp.config.sources({
        { name = 'nvim_lsp',
          option = {
            markdown_oxide = {
              keyword_pattern = [[\(\k\| \|\/\|#\)\+]]
            }
          }
        },
        { name = "neorg" },
        { name = 'luasnip' },
        { name = 'render-markdown' }, -- Assicurati di avere il plugin installato
        { name = 'path' },
      }, {
        { name = 'buffer', keyword_length = 5 },
      }),

      -- FORMATTAZIONE VISIVA
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = format_func,
      },
    }

    -- CONFIGURAZIONE CMDLINE (Ricerca / e ?)
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(get_mappings(true)),
      sources = { { name = 'buffer' } },
      formatting = {
        fields = { 'abbr' },
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(get_mappings(true)),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      }),
      formatting = {
        fields = { 'abbr', 'kind' },
        format = format_func
      },
      matching = { disallow_symbol_nonprefix_matching = false }
    })
  end,
}
