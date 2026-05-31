return {
  {
    "render-markdown.nvim",

    enabled = true,
    auto_enable = false,
    lazy = true,

    ft = { "markdown" },

    after = function(plugin)
      require('render-markdown').setup(plugin.opts or {})
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          local h1_hl = vim.api.nvim_get_hl(0, { name = "RenderMarkdownH1", link = false })
          if h1_hl.fg then
            vim.api.nvim_set_hl(0, "@markup.strong.markdown_inline", { fg = h1_hl.fg, bold = true })
            vim.api.nvim_set_hl(0, "@markup.italic.markdown_inline", { fg = h1_hl.fg, italic = true })
          end
        end,
      })
    end,

    opts = {
      heading = {
        enabled = true,
        sign = true,
        position = 'overlay',
        icons = { '󱘹 ', '󱘹󱘹 ', '󱘹󱘹󱘹 ', '󱘹󱘹󱘹󱘹 ', '󱘹󱘹󱘹󱘹󱘹 ', '󱘹󱘹󱘹󱘹󱘹󱘹 ' },
        signs = { '󰫎 ' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = false,
        border_virtual = false,
        border_prefix = false,
        above = '▁',
        below = '▔',
        backgrounds = {},
        foregrounds = {
          'RenderMarkdownLink', 'RenderMarkdownLink', 'RenderMarkdownLink',
          'RenderMarkdownLink', 'RenderMarkdownLink', 'RenderMarkdownLink',
        },
      },
      paragraph = {
        enabled = false,
        left_margin = 0,
        min_width = 0,
      },
      code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        language_name = true,
        disable_background = { 'diff' },
        width = 'full',
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'thick',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_info = 'RenderMarkdownCode',
        highlight_language = nil,
        highlight_border = false,
        highlight_fallback = 'RenderMarkdownCodeFallback',
        highlight_inline = 'RenderMarkdownCodeInline',
      },
      dash = {
        enabled = true,
        icon = '─',
        width = 'full',
        highlight = 'RenderMarkdownDash',
      },
      bullet = {
        enabled = true,
        icons = { ' ', ' ', ' ', ' ' },
        ordered_icons = function(ctx)
          local value = vim.trim(ctx.value)
          local index = tonumber(value:sub(1, #value - 1))
          return string.format('%d.', index > 1 and index or ctx.index)
        end,
        left_pad = 0,
        right_pad = 0,
        highlight = 'RenderMarkdownH1',
      },
      checkbox = {
        enabled = true,
        unchecked = {
          icon = '',
          highlight = 'RenderMarkdownH1',
        },
        checked = {
          icon = '󰄲',
          highlight = 'RenderMarkdownH1',
        },
        custom = {
          todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownH3', scope_highlight = nil },
          important = { raw = '[~]', rendered = '󰓎 ', highlight = 'DiagnosticWarn' },
        },
      },
      quote = {
        enabled = true,
        icon = '▋',
        repeat_linebreak = true,
        highlight = 'RenderMarkdownQuote',
      },
      pipe_table = {
        enabled = true,
        preset = 'round',
        style = 'full',
        cell = 'padded',
        padding = 1,
        min_width = 0,
        alignment_indicator = '━',
        head = 'RenderMarkdownTableHead',
        row = 'RenderMarkdownTableRow',
        -- Deprecated:?
        --filler = 'RenderMarkdownTableFill',
      },
      callout = {},
      link = {
        enabled = true,
        footnote = {
          superscript = true,
          prefix = '',
          suffix = '',
        },
        image = '󰥶 ',
        email = '󰀓 ',
        hyperlink = '󰌹 ',
        highlight = 'RenderMarkdownLink',
        wiki = { icon = '󱗖 ', highlight = 'RenderMarkdownWikiLink' },
        custom = {
          web = { pattern = '^http', icon = '󰖟 ' },
          youtube = { pattern = 'youtube%.com', icon = '󰗃 ' },
          github = { pattern = 'github%.com', icon = '󰊤 ' },
          neovim = { pattern = 'neovim%.io', icon = ' ' },
          stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
          discord = { pattern = 'discord%.com', icon = '󰙯 ' },
          reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
        },
      },
      sign = {
        enabled = true,
        highlight = 'RenderMarkdownSign',
      },
      indent = {
        enabled = false,
        per_level = 2,
        skip_level = 1,
        skip_heading = true,
      },
      -- Deprecated?
      --frontmatter = {
      --  hidden = true,
      --},
    },
  },
  {
    "markdown-preview.nvim",

    --for_cat = 'markdown',
    enabled = true,
    auto_enable = true,
    lazy = true,

    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle", },
    ft = "markdown",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview <CR>",       mode = { "n" }, noremap = true, desc = "markdown preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop <CR>",   mode = { "n" }, noremap = true, desc = "markdown preview stop" },
      { "<leader>mt", "<cmd>MarkdownPreviewToggle <CR>", mode = { "n" }, noremap = true, desc = "markdown preview toggle" },
    },

    before = function()
      vim.g.mkdp_auto_close = 0
    end,
  },
}
