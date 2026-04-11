-- undoo tree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
--vim.keymap.set('n', '<leader>u', require('undotree').toggle, { noremap = true, silent = true })

-- gen AI
--vim.keymap.set({ 'n', 'v' }, '<leader>]', ':Gen<CR>')

-- Obsidain
vim.keymap.set('n', '<leader>ow', ':ObsidianWorkspace<CR>', { desc = "Show all warkspaces" })
vim.keymap.set('n', '<leader>os', ':ObsidianSearch<CR>', { desc = "Grep in all the vault" })
vim.keymap.set('n', '<leader>ol', ':ObsidianLinks<CR>', { desc = "Show links in the file" })
vim.keymap.set('n', '<leader>ot', ':ObsidianTags<CR>', { desc = "Show the tags created" })
-- 'gf' follow the link
-- 'Invio' follow link and/or check checkbokes

-- prnter setup

--vim.cmd[[nnoremap <leader><leader><leader>pp :r !echo; lpstat -p \| sed 's/printer //g' \| sed 's/is idle.  enabled since.*//g'; echo<cr>]]
--vim.cmd[[nnoremap <leader><leader><leader>ph :w<cr>:!lpoptions -d Smart_Tank_7000<cr>:!lp -n 1 -o media=a4 -o sides=two-sided-long-edge -o page-top=72 -o page-bottom=72 -o page-left=72 -o page-right=72 %<cr><cr>]]

-- For spelling checking
vim.cmd [[nnoremap <leader>it :setlocal spell spelllang=it <cr>]]
vim.cmd [[nnoremap <leader>en :setlocal spell spelllang=en <cr>]]

-- ===============================================
-- Digrafi Personalizzati
-- ===============================================
-- La funzione vim.cmd() esegue un comando Vim.
-- Il numero 8477 è il codice decimale per ℝ (hex 211D).
vim.cmd('digraph RR 8477')
-- Il numero 8469 è il codice decimale per ℕ (hex 2115).
vim.cmd('digraph NN 8469')
vim.cmd('digraph ZZ 8484') -- ℤ (Numeri Interi)
vim.cmd('digraph CC 8450') -- ℂ (Numeri Complessi)

-- Spectre
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
  { desc = "Search current word" })
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
  { desc = "Search on current file" })

-- PRINT
vim.api.nvim_create_user_command(
  'Pprint',
  function()
    local filename = vim.fn.expand('%:p')
    if filename == '' then
      vim.notify("Errore: Salva il file prima di stamparlo.", vim.log.levels.ERROR)
      return
    end

    -- Salva il file
    vim.cmd('write')

    -- Impostazioni di stampa (puoi personalizzarle)
    local copies = '1'
    local sides = 'sides=two-sided-long-edge'
    local media = 'media=A4'
    -- Margini in punti (1cm = ~28.35pt). Qui impostiamo ~2cm per lato.
    local margins = 'page-left=40 page-right=40 page-top=40 page-bottom=40'

    -- Costruisci il comando finale usando `lp` e `string.format`
    local print_command = string.format(
      'lp -n %s -o %s -o %s -o "%s" "%s"',
      copies,
      sides,
      media,
      margins,
      filename
    )

    -- Esegui il comando e controlla se ci sono stati errori
    local result = vim.fn.system(print_command)
    if vim.v.shell_error ~= 0 then
      vim.notify("Errore durante la stampa: " .. result, vim.log.levels.ERROR)
    else
      vim.notify("File inviato alla stampante: " .. vim.fn.fnamemodify(filename, ':t'))
    end
  end,
  {
    nargs = 0,
    desc = 'Salva il file corrente e lo stampa con margini e fronte-retro'
  }
)

vim.api.nvim_create_user_command(
  'PprintMdPdf',
  function()
    local md_filename = vim.fn.expand('%:p')
    if not string.match(md_filename, '%.md$') then
      vim.notify("Errore: Il file non è un Markdown (.md).", vim.log.levels.ERROR)
      return
    end

    vim.cmd('write')

    -- Impostazioni per una conversione robusta
    local pandoc_flags = {
      '-s',
      '--template=eisvogel',
      '--pdf-engine=xelatex',
      '-t', 'pdf',
      '-H', vim.fn.expand('~/.config/pandoc/preamble.tex'),
      --'-V', 'documentclass=scrartcl',
      --'-V lang=it-IT',            -- Imposta la lingua italiana
      '-V mainfont="Hack Nerd Font"',
      '-V monofont="0xProto Nerd Font"'
    }

    -- Comando Pandoc: unisce i flag e il nome del file
    local pandoc_cmd = 'pandoc ' .. table.concat(pandoc_flags, ' ') .. ' "' .. md_filename .. '"'

    -- Comando di stampa (invariato)
    local print_job_title = vim.fn.expand('%:t')
    local lp_cmd = string.format(
      'lp -o sides=two-sided-long-edge -o media=A4 -t "%s"',
      print_job_title
    )

    -- Unisci i comandi con una pipe
    local full_command = pandoc_cmd .. ' | ' .. lp_cmd

    vim.notify("Avvio conversione robusta e stampa per " .. print_job_title .. "...")

    -- Esegui il comando completo
    local result = vim.fn.system(full_command)
    if vim.v.shell_error ~= 0 then
      vim.notify("Errore durante il processo: " .. result, vim.log.levels.ERROR)
    else
      vim.notify("Documento inviato alla stampante con successo!", vim.log.levels.INFO)
    end
  end,
  {
    nargs = 0,
    desc = 'Converte il MD in PDF in modo robusto e lo stampa.'
  }
)


-- NORG mode
-- Mappatura specifica per i file Neorg
vim.api.nvim_create_autocmd("FileType", {
  pattern = "norg",
  callback = function()
    -- Remap di gd per simulare la pressione di Invio (che Neorg usa per i link)
    vim.keymap.set("n", "gd", "<CR>", { buffer = true, remap = true })
  end,
})
