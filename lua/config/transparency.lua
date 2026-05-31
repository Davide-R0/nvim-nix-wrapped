vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
  pattern = "*",
  desc = "Force transparent background for UI elements",
  callback = function()
    -- Funzione per rimuovere solo lo sfondo, preservando fg e stili
    local function set_transparent(group)
      ---@type any
      local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
      if not hl or vim.tbl_isempty(hl) then return end
      hl.bg = nil
      hl.ctermbg = nil
      hl.force = true
      vim.api.nvim_set_hl(0, group, hl)
    end

    -- Gruppi base, ui e plugin
    local groups = {
      "Normal", "NormalNC", "StatusLine", "StatusLineNC", "EndOfBuffer",
      "CmpItemAbbr", "CmpItemAbbrDeprecated", "CmpItemAbbrMatch", "CmpDocumentation", "CmpDocumentationBorder",
      "NormalFloat", "FloatBorder", "Pmenu", "PmenuBorder",
      "TelescopeNormal", "FidgetNormal", "FidgetBorder",
      "WhichKey", "WhichKeyFloat", "WhichKeyGroup",
      "LazyNormal", "MasonNormal",
      "DiagnosticVirtualTextError", "DiagnosticVirtualTextWarn", "DiagnosticVirtualTextInfo", "DiagnosticVirtualTextHint",
      "TreesitterContext", "TreesitterContextLineNumber",
      "SignColumn", "ColorColumn", "CursorLineSign", "FoldColumn",
      --"DiffAdd", "DiffChange", "DiffDelete", "DiffText", -- se si mettono questi poi i diff in nvim non osno colorati

      -- Telescope
      --"TelescopeBorder", "TelescopeResultsBorder", "TelescopeResultsTitle",
      --"TelescopePromptBorder", "TelescopePromptTitle", "TelescopePreviewBorder",
      --"TelescopePreviewTitle", "TelescopePromptNormal", "TelescopePreviewNormal",
      --"TelescopeResultsNormal", "TelescopePromptPrefix"
    }

    -- Generazione dinamica dei gruppi gitsigns
    -- Genera automaticamente tutte le 48 combinazioni (Add, Change, Staged, Nr, Ln, Cul, ecc.)
    local git_prefixes = { "GitSigns", "GitSignsStaged" }
    local git_actions = { "Add", "Change", "Delete", "Untracked", "Changedelete", "Topdelete" }
    local git_suffixes = { "", "Nr", "Ln", "Cul" }

    for _, prefix in ipairs(git_prefixes) do
      for _, action in ipairs(git_actions) do
        for _, suffix in ipairs(git_suffixes) do
          table.insert(groups, prefix .. action .. suffix)
        end
      end
    end

    -- Applica la trasparenza a tutti i gruppi
    for _, group in ipairs(groups) do
      set_transparent(group)
    end

    -- Applica i collegamenti (links)
    local links = {
      LazyButtonActive = "Visual",
      LazyH1 = "Title",
      LazySpecial = "Constant",
      PmenuSel = "Visual",
      TelescopeSelection = "Visual",
    }

    for from, to in pairs(links) do
      vim.api.nvim_set_hl(0, from, { link = to })
    end

    -- Telescope
    local telescope_groups = {
      "TelescopeBorder", "TelescopeResultsBorder", "TelescopeResultsTitle",
      "TelescopePromptBorder", "TelescopePromptTitle", "TelescopePreviewBorder",
      "TelescopePreviewTitle", "TelescopePromptNormal", "TelescopePreviewNormal",
      "TelescopeResultsNormal", "TelescopePromptPrefix"
    }

    for _, group in ipairs(telescope_groups) do
      -- Passando solo bg=nil, si elimina il colore (fg) del tema
      vim.api.nvim_set_hl(0, group, { bg = nil, ctermbg = nil })
    end
  end,
})

-- Force the execution
vim.cmd("doautocmd ColorScheme")
