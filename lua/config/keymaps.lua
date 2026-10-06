-- Spell checking
--vim.keymap.set('n', '<leader>it', '<cmd>setlocal spell spelllang=it<cr>', { desc = "Set spell language to IT" })
--vim.keymap.set('n', '<leader>en', '<cmd>setlocal spell spelllang=en<cr>', { desc = "Set spell language to EN" }) -- WARN: questo va in conflitto con la keymaps per la diagnostic del lsp

-- Navigazione riga: H = inizio riga (primo non-vuoto), L = fine riga
-- Valgono in normale, visual e operator-pending (es. dL, y H)
vim.keymap.set({ "n", "x", "o" }, "H", "^", { desc = "Vai a inizio riga" })
vim.keymap.set({ "n", "x", "o" }, "L", "$", { desc = "Vai a fine riga" })

-- Markdown: grassetto (**...**) sulla selezione in visual
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function(args)
    vim.keymap.set("x", "B", "c**<C-r>\"**<Esc>", {
      buffer = args.buf,
      silent = true,
      desc = "Markdown: grassetto selezione",
    })
  end,
})
