-- Spell checking
vim.keymap.set('n', '<leader>it', '<cmd>setlocal spell spelllang=it<cr>', { desc = "Set spell language to IT" })
vim.keymap.set('n', '<leader>en', '<cmd>setlocal spell spelllang=en<cr>', { desc = "Set spell language to EN" })

-- Digrafi Personalizzati
vim.cmd([[
  digraph RR 8477
  digraph NN 8469
  digraph ZZ 8484
  digraph CC 8450
]])
-- ℝ
-- ℕ
-- ℤ
-- ℂ
