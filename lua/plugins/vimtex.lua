return {
  "vimtex",

  enabled = true,
  auto_enable = false,
  lazy = true,

  ft = { "tex" },

  before = function()
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_quickfix_mode = 0
  end,

  after = function()
  end
}
