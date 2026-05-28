return {
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
    backend = "ueberzug",
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
}
