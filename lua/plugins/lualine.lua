return {
  {
    "lualine.nvim",
    auto_enable = true,
    enabled = true,
    event = "DeferredUIEnter",
    after = function()
      local auto_theme = require('lualine.themes.auto')

      local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
      for _, mode in ipairs(modes) do
        if auto_theme[mode] then
          if auto_theme[mode].c then auto_theme[mode].c.bg = "NONE" end
        end
      end

      require('lualine').setup({
        options = {
          icons_enabled = true,
          theme = auto_theme,
          component_separators = '',
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = {
            { 'mode', right_padding = 2 },
          },
          lualine_b = {
            'filename',
            'branch',
            'diff',
            'diagnostics',
          },
          lualine_c = {
            {'filename', path = 1},
            '%=',
          },
          lualine_y = { 'progress',  },
          lualine_z = { { 'location', left_padding = 2 }, },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {'oil', 'fzf', 'fugitive', 'nvim-dap-ui'},
      })
    end,
  },
  {
    "nvim-web-devicons",
    auto_enable = true,
    enabled = vim.g.have_nerd_font,
    dep_of = { "lualine.nvim" }
  }
}
