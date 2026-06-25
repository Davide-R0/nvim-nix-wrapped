return {
  {
    "image.nvim",

    enable = true,
    auto_enable = false,
    lazy = true,

    ft = { "markdown", "vimwiki", "norg" },

    event = {
      "BufReadPre *.png",
      "BufReadPre *.jpg",
      "BufReadPre *.jpeg",
      "BufReadPre *.gif",
      "BufReadPre *.webp",
      "BufReadPre *.avif",
    },

    after = function(plugin)
      require("image").setup(plugin.opts)
    end,

    opts = {
      backend = nixInfo("kitty", "settings", "render-backend"),
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = false,
          only_render_image_at_cursor = true,
          floating_windows = true,
          filetypes = { "markdown", "vimwiki" },
          resolve_image_path = function(document_path, image_path, fallback)
            return fallback(document_path, image_path)
          end,
        },
        neorg = {
          enabled = true,
          filetypes = { "norg" },
        },
        html = { enabled = false },
        css = { enabled = false },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 70,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    },
  },
  -- {
  --   "diagram.nvim",
  --
  --   enable = true,
  --   auto_enable = false,
  --   lazy = true,
  --
  --   ft = { "markdown", "vimwiki", "norg" },
  --
  --   dependencies = {
  --     { "3rd/image.nvim", opts = {} }, -- you'd probably want to configure image.nvim manually instead of doing this
  --   },
  --
  --   after = function(plugin)
  --     require("diagram").setup(plugin.opts)
  --   end,
  --
  --   opts = {
  --     events = {
  --       render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
  --       clear_buffer = { "BufLeave" },
  --     },
  --     renderer_options = {
  --       mermaid = {
  --         background = nil, -- nil | "transparent" | "white" | "#hex"
  --         theme = nil,      -- nil | "default" | "dark" | "forest" | "neutral"
  --         scale = 1,        -- nil | 1 (default) | 2  | 3 | ...
  --         width = nil,      -- nil | 800 | 400 | ...
  --         height = nil,     -- nil | 600 | 300 | ...
  --         cli_args = nil,   -- nil | { "--no-sandbox" } | { "-p", "/path/to/puppeteer" } | ...
  --       },
  --       plantuml = {
  --         charset = nil,
  --         cli_args = nil, -- nil | { "-Djava.awt.headless=true" } | ...
  --       },
  --       d2 = {
  --         theme_id = nil,
  --         dark_theme_id = nil,
  --         scale = nil,
  --         layout = nil,
  --         sketch = nil,
  --         cli_args = nil, -- nil | { "--pad", "0" } | ...
  --       },
  --       gnuplot = {
  --         size = nil,     -- nil | "800,600" | ...
  --         font = nil,     -- nil | "Arial,12" | ...
  --         theme = nil,    -- nil | "light" | "dark" | custom theme string
  --         cli_args = nil, -- nil | { "-p" } | { "-c", "config.plt" } | ...
  --       },
  --     }
  --   },
  -- },

}
