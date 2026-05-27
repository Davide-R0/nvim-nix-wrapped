return {
  {
    "nvim-lint",
    auto_enable = true,
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    after = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint-cli2' },
        sh = { 'shellcheck' },
        bash = { 'shellcheck' },
        lua = { 'selene' },
        python = { 'ruff' },
        nix = { 'statix', 'deadnix' },
        cpp = { 'cppcheck' },
        c = { 'cppcheck' },
        tex = { 'chktex' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  }
}
