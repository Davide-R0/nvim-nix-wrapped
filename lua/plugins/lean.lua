return {
  "lean.nvim",

  enable = true,
  auto_enable = false,
  lazy = true,

  ft = { "lean" },
  --event = { "BufReadPre *.lean", "BufNewFile *.lean" },

  after = function(plugin)
    require("lean").setup(plugin.opts)
  end,

  opts = {
    mappings = true,
    ft = {
      nomodifiable = {}
    },
    abbreviations = {
      enable = true,
      extra = { wknight = '♘' },
      leader = '\\',
    },
    infoview = {
      autoopen = true,
      width = 50,
      height = 20,
      orientation = "auto",
      horizontal_position = "bottom",
      separate_tab = false,
      indicators = "auto",
    },
    progress_bars = {
      enable = true,
      character = '│',
      priority = 10,
    },
    stderr = {
      enable = true,
      height = 5,
      on_lines = nil,
    },
  }
}
