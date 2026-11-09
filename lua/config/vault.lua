-- Modalità vault: per modificare file sensibili senza lasciarne copie in chiaro.
-- Si attiva con `nvim --cmd 'let g:vault = 1'` (alias `vvim`).
-- Tema, tasti e plugin restano quelli normali; si spengono solo:
--   - undo persistente, swap, backup e shada
--   - clipboard di sistema (unnamedplus)
--   - LSP e plugin di AI
local M = {}

M.enabled = vim.g.vault == 1 or vim.g.vault == true

-- Da chiamare dopo config.options, così sovrascrive i valori normali
function M.setup()
  if not M.enabled then
    return
  end

  -- Niente su disco oltre al file stesso
  vim.opt.undofile = false
  vim.opt.swapfile = false
  vim.opt.backup = false
  vim.opt.writebackup = false
  -- shada viene letto dopo init.lua: impostarlo qui basta per non leggerlo né scriverlo
  vim.opt.shadafile = "NONE"
  vim.opt.shada = ""

  -- Lo yank resta nei registri interni, non finisce nella clipboard di sistema
  vim.opt.clipboard = ""

  -- Rete di sicurezza: nessun client LSP parte, anche se un plugin
  -- (lean.nvim, crates.nvim, ...) prova ad avviarlo per conto suo
  vim.lsp.enable = function() end
  vim.lsp.start = function() end

  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.notify("󰌾 Modalità vault: niente undo/swap/shada/clipboard, LSP e AI spenti",
        vim.log.levels.WARN)
    end,
  })
end

-- Avvolge un handler lze: in vault disabilita le spec che usano il suo
-- spec_field (se `pred` le accetta), altrimenti chiama il modify originale.
-- Le spec arrivano da mod_dir_to_spec come `{ import = ... }`, quindi
-- l'unico punto in cui si vedono i campi veri è il modify degli handler.
-- lze salta i modify successivi sulle spec già disabilitate.
function M.guard_handler(handler, pred)
  if not M.enabled then
    return handler
  end
  local modify = handler.modify
  return vim.tbl_extend("force", handler, {
    modify = function(plugin)
      if not pred or pred(plugin) then
        plugin.enabled = false
        return plugin
      end
      if modify then
        return modify(plugin)
      end
      return plugin
    end,
  })
end

return M
