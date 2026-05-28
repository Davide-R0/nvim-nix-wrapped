return {
  {
    "telescope.nvim",
    enabled = true,
    auto_enable = false,
    lazy = true,

    cmd = { "Telescope" },
    keys = {
      { "<leader>sh",       "<cmd>Telescope help_tags<CR>",    desc = "[S]earch [H]elp" },
      { "<leader>sk",       "<cmd>Telescope keymaps<CR>",      desc = "[S]earch [K]eymaps" },
      { "<leader>sf",       "<cmd>Telescope find_files<CR>",   desc = "[S]earch [F]iles" },
      { "<leader>ss",       "<cmd>Telescope builtin<CR>",      desc = "[S]earch [S]elect Telescope" },
      { "<leader>sw",       "<cmd>Telescope grep_string<CR>",  desc = "[S]earch current [W]ord" },
      { "<leader>sg",       "<cmd>Telescope live_grep<CR>",    desc = "[S]earch by [G]rep" },
      { "<leader>sd",       "<cmd>Telescope diagnostics<CR>",  desc = "[S]earch [D]iagnostics" },
      { "<leader>sr",       "<cmd>Telescope resume<CR>",       desc = "[S]earch [R]esume" },
      { "<leader>s.",       "<cmd>Telescope oldfiles<CR>",     desc = "[S]earch Recent Files" },
      { "<leader><leader>", "<cmd>Telescope buffers<CR>",      desc = "[ ] Find existing buffers" },
      { "<leader>sb",       "<cmd>Telescope buffers<CR>",      desc = "[S]earch existing [B]uffers" },
      { "<leader>sc",       "<cmd>Telescope commands<CR>",     desc = "[S]earch [C]ommands" },
      { "<leader>gc",       "<cmd>Telescope git_commits<CR>",  desc = "[G]it [C]ommits" },
      { "<leader>gs",       "<cmd>Telescope git_status<CR>",   desc = "[G]it [S]tatus" },
      { "<leader>gb",       "<cmd>Telescope git_branches<CR>", desc = "[G]it [B]ranches" },
      { "<leader>st",       "<cmd>Telescope tags<CR>",         desc = "[S]earch [T]ags" },
      { "<leader>sm",       "<cmd>Telescope media_files<CR>",  desc = "[S]earch [M]edia" },
      { "<leader>nm",       "<cmd>Telescope manix<CR>",        desc = "[N]ix [M]anix Options" },
      {
        "<leader>/",
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 0,
            previewer = false,
          })
        end,
        desc = "[/] Fuzzily search in current buffer"
      },
      {
        "<leader>sn",
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath('config') }
        end,
        desc = "[S]earch [N]eovim files"
      },
    },

    dep_of = { "codecompanion.nvim" },
    branch = '0.1.x',

    after = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

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
            filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf", "svg" },
            find_cmd = "fd",
          }
        },
      }

      -- Carichiamo le estensioni (le dipendenze sono state già svegliate da Lze!)
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'ui-select')
      pcall(telescope.load_extension, 'media_files')
      pcall(telescope.load_extension, 'manix')
    end,

    -- OLD
    -- TODO: mettere in realtà in before solo le keybindings, e after il caricamento dei plugin di telescope
    --after = function()
    --  local telescope = require('telescope')
    --  local actions = require('telescope.actions')
    --  local builtin = require('telescope.builtin')

    --  telescope.setup {
    --    defaults = {
    --      mappings = {
    --        i = {
    --          ['<C-y>'] = actions.select_default,
    --        },
    --        n = {
    --          ['q'] = actions.close,
    --        },
    --      },
    --    },
    --    extensions = {
    --      ['ui-select'] = {
    --        require('telescope.themes').get_dropdown(),
    --      },
    --      media_files = {
    --        filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf", "svg" },
    --        find_cmd = "fd",
    --      }
    --    },
    --  }

    --  pcall(telescope.load_extension, 'fzf')
    --  pcall(telescope.load_extension, 'ui-select')
    --  pcall(telescope.load_extension, 'media_files')
    --  pcall(telescope.load_extension, 'manix')

    --  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    --  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    --  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    --  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    --  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    --  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    --  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    --  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    --  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
    --  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    --  vim.keymap.set('n', '<leader>sb', builtin.buffers, { desc = '[S]earch existing [B]uffers' })
    --  vim.keymap.set('n', '<leader>sk', builtin.commands, { desc = '[S]earch [K]ommands' })
    --  vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = '[G]it [C]ommits' })
    --  vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[G]it [S]tatus' })
    --  vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })
    --  vim.keymap.set('n', '<leader>st', builtin.tags, { desc = '[S]earch [T]ags' })
    --  vim.keymap.set('n', '<leader>sd', builtin.lsp_document_symbols, { desc = '[S]earch [D]ocument Symbols' })
    --  vim.keymap.set('n', '<leader>sm', ':Telescope media_files<CR>', { desc = '[S]earch [M]edia' })
    --  vim.keymap.set('n', '<leader>nm', function() telescope.extensions.manix.manix() end,
    --    { desc = '[N]ix [M]anix Options' })

    --  vim.keymap.set('n', '<leader>/', function()
    --    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --      winblend = 0,
    --      previewer = false,
    --    })
    --  end, { desc = '[/] Fuzzily search in current buffer' })

    --  vim.keymap.set('n', '<leader>sn', function()
    --    builtin.find_files { cwd = vim.fn.stdpath 'config' }
    --  end, { desc = '[S]earch [N]eovim files' })
    --end,
  },
  {
    "telescope-fzf-native.nvim",
    enabled = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "telescope.nvim" }
  },
  {
    "telescope-ui-select.nvim",
    enabled = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "telescope.nvim" }
  },
  {
    "telescope-media-files.nvim",
    enabled = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "telescope.nvim" }
  },
  {
    "telescope-manix",
    enabled = true,
    auto_enable = true,
    lazy = true,
    dep_of = { "telescope.nvim" }
  }
}
