return {
  {
    "vimtex",
    auto_enable = true,
    event = "DeferredUIEnter",
    before = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
    end,
    after = function()
    end
  }
}
