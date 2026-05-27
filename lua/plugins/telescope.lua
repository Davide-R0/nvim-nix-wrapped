return {
  {
    "telescope.nvim",
    auto_enable = true,
    event = 'VimEnter',
    branch = '0.1.x',
    after = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      telescope.setup {
        defaults = {
          mappings = {
            i = {
              ['<C-y>'] = actions.select_default,
            },
            n = {
               ['q'] = actions.close,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          media_files = {
            filetypes = {"png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf", "svg"},
            find_cmd = "fd",
          }
        },
      }

      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'media_files')
      pcall(telescope.load_extension, 'manix')

      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch existing [B]uffers' })
      vim.keymap.set('n', '<leader>sk', builtin.commands, { desc = '[S]earch [K]ommands' })
      vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
      vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>st', builtin.tags, { desc = '[S]earch [T]ags' })
      vim.keymap.set('n', '<leader>sd', builtin.lsp_document_symbols, { desc = '[S]earch [D]ocument Symbols' })
      vim.keymap.set('n', '<leader>sm', ':Telescope media_files<CR>', { desc = '[S]earch [M]edia' })
      vim.keymap.set('n', '<leader>nm', function() telescope.extensions.manix.manix() end, { desc = '[N]ix [M]anix Options' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 0,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    "plenary.nvim",
    auto_enable = true,
    dep_of = { "telescope.nvim" }
  },
  {
    "telescope-fzf-native.nvim",
    auto_enable = true,
    dep_of = { "telescope.nvim" }
  },
  {
    "telescope-ui-select.nvim",
    auto_enable = true,
    dep_of = { "telescope.nvim" }
  },
  {
    "nvim-web-devicons",
    auto_enable = true,
    enabled = vim.g.have_nerd_font,
    dep_of = { "telescope.nvim" }
  },
  {
    "telescope-media-files.nvim",
    auto_enable = true,
    dep_of = { "telescope.nvim" }
  },
  {
    "telescope-manix",
    auto_enable = true,
    dep_of = { "telescope.nvim" }
  }
}
