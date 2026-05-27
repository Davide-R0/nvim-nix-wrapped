return {
  {
    "lean.nvim",
    auto_enable = true,
    event = { "BufReadPre *.lean", "BufNewFile *.lean" },
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
  },
  {
    "nvim-lspconfig",
    auto_enable = true,
    dep_of = { "lean.nvim" }
  },
  {
    "plenary.nvim",
    auto_enable = true,
    dep_of = { "lean.nvim" }
  }
}
