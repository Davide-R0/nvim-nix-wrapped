return {
  {
    "nvim-cmp",

    enable = true,
    auto_enable = false,
    lazy = false,

    after = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

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
        CMPAI = '🤖',
      }

      local format_func = function(entry, vim_item)
        if kind_icons[vim_item.kind] then
          vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind)
        end

        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          cmp_ai = '[AI]',
          luasnip = '[Snip]',
          buffer = '[Buf]',
          path = '[Path]',
          cmdline = '',
        })[entry.source.name]

        if entry.source.name == 'cmdline' or entry.source.name == 'path' then
          vim_item.kind = ''
        end

        return vim_item
      end

      local function get_mappings(is_cmdline)
        return {
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-Space>'] = cmp.mapping.complete({}),
        }
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
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
        mapping = cmp.mapping.preset.insert(get_mappings(false)),
        sources = cmp.config.sources({
          { name = 'nvim_lsp',       option = { markdown_oxide = { keyword_pattern = [[\(\k\| \|\/\|#\)\+]] } } },
          { name = "neorg" },
          { name = 'luasnip' },
          { name = 'render-markdown' },
          { name = 'path' },
        }, {
          { name = 'buffer', keyword_length = 5 },
        }),
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
          format = format_func,
        },
      }

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
  },
  {
    "cmp_luasnip",
    enable = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "nvim-cmp" },
  },
  {
    "cmp-nvim-lsp",
    enable = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "nvim-cmp", "nvim-lspconfig" },
  },
  {
    "cmp-path",
    enable = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "nvim-cmp" },
  },
  {
    "cmp-buffer",
    enable = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "nvim-cmp" },
  },
  {
    "cmp-cmdline",
    enable = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "nvim-cmp" },
  }
}
