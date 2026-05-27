return {
  {
    "nvim-autopairs",
    auto_enable = true,
    enabled = true,
    event = 'InsertEnter',
    after = function()
      require('nvim-autopairs').setup {}
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    "nvim-cmp",
    auto_enable = true,
    dep_of = { "nvim-autopairs" },
  }
}
