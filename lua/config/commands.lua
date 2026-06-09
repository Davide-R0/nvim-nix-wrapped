-- Digrafi Personalizzati ℝ ℕ ℤ ℂ
vim.cmd([[
  digraph RR 8477
  digraph NN 8469
  digraph ZZ 8484
  digraph CC 8450
]])

-- Riconoscimento file GLSL
vim.filetype.add({
  extension = {
    vs = 'glsl',
    fs = 'glsl',
    cp = 'glsl',
    vert = 'glsl',
    frag = 'glsl',
    comp = 'glsl',
  }
})

vim.filetype.add({
  extension = {
    puml = 'plantuml',
    pu = 'plantuml',
    uml = 'plantuml',
    plantuml = 'plantuml',
  },
})

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

-- =============================================================================
-- COMANDI DI DEBUG PER LZE E NIX ( :Lze... )
-- =============================================================================

-- 1. Vedere i plugin riconosciuti da Nix
vim.api.nvim_create_user_command("LzeNix", function()
  if _G.nixInfo then
    local ok, debug = pcall(require, "lzextras")
    if ok and debug.debug then
      debug.debug.display(nixInfo(nil, "plugins"))
    else
      vim.print(nixInfo(nil, "plugins"))
    end
  end
end, { desc = "Mostra plugin Nix" })

vim.api.nvim_create_user_command("LzeStatus", function()
  local rtp = vim.api.nvim_list_runtime_paths()
  local active_plugins = {}

  -- 1. Capiamo quali plugin sono ATTUALMENTE IN ESECUZIONE (nel RuntimePath)
  for _, path in ipairs(rtp) do
    local name = path:match("/pack/[^/]+/[^/]+/([^/]+)")
    if not name then name = path:match("/nix/store/[a-z0-9]+%-([^/]+)") end
    if not name then name = path:match("([^/\\]+)$") end

    if name then
      name = name:gsub("^vimplugin%-", ""):gsub("^luajit[%w%.%-]+%-", ""):gsub("%-source$", "")
      active_plugins[name] = true
    end
  end

  -- 2. Troviamo TUTTI i plugin installati nel sistema esplorando i packpath
  local all_plugins = {}
  local packpaths = vim.fn.globpath(vim.o.packpath, "pack/*/*/*", false, true)

  for _, path in ipairs(packpaths) do
    local folder, name = path:match("/pack/[^/]+/([^/]+)/([^/]+)")
    if name then
      name = name:gsub("^vimplugin%-", ""):gsub("^luajit[%w%.%-]+%-", ""):gsub("%-source$", "")
      if name ~= "site" and name ~= "nvim" and name ~= "vim" and name ~= "pack" then
        -- Salviamo il plugin: la sua cartella di origine e se è attualmente nel RTP
        all_plugins[name] = {
          folder = folder:upper(), -- Sarà 'START' o 'OPT'
          is_loaded = active_plugins[name] == true
        }
      end
    end
  end

  -- Fallback: Se c'è un plugin in RTP (iniettato direttamente da Nix) che non era nel packpath
  for name, _ in pairs(active_plugins) do
    if not all_plugins[name] and name ~= "site" and name ~= "nvim" and name ~= "vim" and name ~= "pack" then
      all_plugins[name] = { folder = "NIX", is_loaded = true }
    end
  end

  -- Ordinamento alfabetico
  local sorted_names = {}
  for name, _ in pairs(all_plugins) do table.insert(sorted_names, name) end
  table.sort(sorted_names)

  -- 3. Costruiamo le righe della finestra
  local lines = {}
  table.insert(lines, string.format(" %-35s | %-6s | %-15s ", "Plugin", "Orig", "State"))
  table.insert(lines, string.rep("-", 65))

  local count_loaded = 0
  local count_total = 0

  for _, name in ipairs(sorted_names) do
    local info = all_plugins[name]
    -- Se è in RTP è caricato, altrimenti è in panchina ad aspettare Lze
    local status_icon = info.is_loaded and "🟢 LOADED" or "⭕ not loaded"

    if info.is_loaded then count_loaded = count_loaded + 1 end
    count_total = count_total + 1

    table.insert(lines, string.format(" %-35s | %-6s | %-15s ", name, info.folder, status_icon))
  end

  table.insert(lines, string.rep("-", 65))
  table.insert(lines, string.format(" Total: %d installed | %d currently running", count_total, count_loaded))
  table.insert(lines, "")
  table.insert(lines, " (Press 'q' to close) ")

  -- 4. Creiamo il buffer temporaneo
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true

  -- 5. Calcoliamo layout e apriamo la finestra
  local width = 70
  local height = math.min(#lines, math.floor(vim.o.lines * 0.8))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " Monitoraggio Plugin ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", { buffer = buf, silent = true }) -- Aggiunta
end, { desc = "Shows all installed plugins and their status in real time" })

-- Tab space for some files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix", "lua", "json", "jsonc", "yaml", "html", "css", "scss", "javascript", "typescript", "javascriptreact", "typescriptreact", "ruby" },
  callback = function(args)
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
    -- Fix specifico per Nix (e altri linguaggi che usano # per i commenti)
    if args.match == "nix" or args.match == "ruby" or args.match == "python" then
      -- Disabilita smartindent (è spesso lui che spara il # a inizio riga)
      vim.opt_local.smartindent = false
      -- Rimuove la regola 0# da indentkeys (se presente)
      vim.opt_local.indentkeys:remove("0#")
      -- Rimuove la regola 0# da cinkeys (spesso usata come fallback)
      vim.opt_local.cinkeys:remove("0#")
    end
  end,
})

local function insert_md_yaml()
  if vim.bo.filetype ~= "markdown" then
    vim.notify("This is not a md file!", vim.log.levels.WARN)
    return
  end

  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

  if first_line == "---" then
    vim.notify("Header YAML already present.", vim.log.levels.INFO)
  else
    local header = {
      "---",
      "title: \"" .. vim.fn.expand("%:t:r") .. "\"", -- Prende il nome del file senza estensione
      "date: " .. os.date("%Y-%m-%d"),               -- %H:%M
      "#subtitle: \"The Document SubTitle\"",
      "author: []",
      "lang: it-IT",
      "tags: []",
      "draft: false",
      "# ------setings------- #",
      "geometry: \"a4paper, left=2cm, right=2cm, top=3cm, bottom=3cm\"",
      "mainfont: \"CMU Bright\"",
      "monofont: \"NotoSansMono\"",
      "fontsize: 11pt",
      "numbersections: true",
      "toc-depth: 4",
      "listings-disable-line-numbers: false",
      "listings-no-page-break: true",
      "table-use-row-colors: true",
      "# ------commands------- #",
      "# \\maketitle \\newpage \\tableofcontents \\newpage",
      "# pandoc --template=\"path/to/template.tex\" -H \"path/to/preamble.tex\" --listings --pdf-engine=lualatex --resource-path=\"image/path/\" input.md -o output.pdf",
      "---",
      "",
    }

    vim.api.nvim_buf_set_lines(0, 0, 0, false, header)
    vim.notify("Header YAML inserted successfully.", vim.log.levels.INFO)
  end
end
vim.api.nvim_create_user_command("MdYamlHeader", insert_md_yaml, { desc = "Insert YAML header in a markdown file." })

local function compile_markdown_to_pdf()
  local input = vim.fn.expand("%:p") -- Percorso assoluto del file attuale
  local output = vim.fn.expand("%:p:r") .. ".pdf"

  if input == "" then
    vim.notify("Error: save the document before compiling", vim.log.levels.ERROR)
    return
  end

  -- NOTE: use absolute path
  local config = {
    template = vim.env.XDG_CONFIG_HOME .. "/pandoc/eisvogel.latex",
    preamble = vim.env.XDG_CONFIG_HOME .. "/pandoc/preamble.tex",
    --filter   = "path/to/filter.lua",
    --res_path = "image/path/",
  }

  local cmd = string.format(
    "pandoc --template=%s -H %s --pdf-engine=lualatex  %s -o %s", -- --listings  -L %s resource-path=%s
    vim.fn.shellescape(config.template),
    vim.fn.shellescape(config.preamble),
    vim.fn.shellescape(input),
    vim.fn.shellescape(output)
  --vim.fn.shellescape(config.filter)
  --vim.fn.shellescape(config.res_path)
  )

  print("Compilation...")
  vim.cmd("! " .. cmd)
end

vim.api.nvim_create_user_command("MdToPdf", compile_markdown_to_pdf, { desc = "Compile MD to PDF via Pandoc" })

--------------
-- PlantUML --
--------------
-- Gruppo globale per isolare gli eventi di compilazione PlantUML
local puml_group = vim.api.nvim_create_augroup("PlantUMLCompiler", { clear = true })

-- Funzione di supporto parametrica con pipeline UNIX per Scrittura Atomica
local function compile_plantuml(filepath, ext)
  local image_file = vim.fn.expand("%:p:r") .. "." .. ext
  local tmp_file = image_file .. ".tmp"

  -- Escape rigoroso dei percorsi per gestire spazi o caratteri speciali nel filesystem
  local safe_in = vim.fn.shellescape(filepath)
  local safe_tmp = vim.fn.shellescape(tmp_file)
  local safe_out = vim.fn.shellescape(image_file)

  -- Generazione della pipeline condizionale (compilazione su tmp -> rename atomico)
  local cmd = string.format("plantuml -pipe -t%s < %s > %s && mv %s %s", ext, safe_in, safe_tmp, safe_tmp, safe_out)

  vim.fn.jobstart({ "sh", "-c", cmd }, {
    on_exit = function(_, exit_code, _)
      if exit_code == 0 then
        vim.notify(string.format("PlantUML: Compilazione %s atomica completata.", ext:upper()), vim.log.levels.INFO)
      else
        vim.notify(string.format("PlantUML: Errore critico di compilazione %s.", ext:upper()), vim.log.levels.ERROR)
      end
    end,
  })
end

-- Funzione core di astrazione per il Bootstrap della preview
local function bootstrap_preview(ext, imv_flags)
  local current_buf = vim.api.nvim_get_current_buf()
  local filepath = vim.fn.expand("%:p")
  local image_file = vim.fn.expand("%:p:r") .. "." .. ext

  -- Controllo dello stato del buffer per impedire istanze di monitoraggio sovrapposte
  if vim.b[current_buf].plantuml_preview_active then
    vim.notify("PlantUML: Una sessione di preview è già attiva per questo buffer.", vim.log.levels.WARN)
    return
  end

  vim.notify(string.format("PlantUML: Inizializzazione motore di rendering %s...", ext:upper()), vim.log.levels.INFO)

  -- Compilazione iniziale sincrona rispetto all'apertura del visualizzatore
  vim.fn.jobstart({ "plantuml", "-t" .. ext, filepath }, {
    on_exit = function(_, exit_code, _)
      if exit_code == 0 then
        -- Costruzione dinamica del comando di invocazione per imv
        local imv_cmd = { "imv" }
        for _, flag in ipairs(imv_flags) do
          table.insert(imv_cmd, flag)
        end
        table.insert(imv_cmd, image_file)

        -- Esecuzione del visualizzatore in un processo distaccato (detached)
        vim.fn.jobstart(imv_cmd, { detach = true })

        -- Registrazione dell'autocommand buffer-local vincolato al formato scelto
        vim.api.nvim_create_autocmd("BufWritePost", {
          group = puml_group,
          buffer = current_buf,
          callback = function()
            compile_plantuml(filepath, ext)
          end,
        })

        -- Mutazione dello stato del buffer
        vim.b[current_buf].plantuml_preview_active = true
        vim.notify(string.format("PlantUML: Preview %s instradata. Configurazione salvataggio armata.", ext:upper()),
          vim.log.levels.INFO)
      else
        vim.notify("PlantUML: Fallimento durante il bootstrap. Verificare la sintassi del codice.", vim.log.levels.ERROR)
      end
    end
  })
end

-- Funzione core per la rimozione dei listener e abbattimento dei processi
local function stop_preview()
  local current_buf = vim.api.nvim_get_current_buf()

  if not vim.b[current_buf].plantuml_preview_active then
    vim.notify("PlantUML: Nessuna sessione di preview attiva su questo buffer.", vim.log.levels.WARN)
    return
  end

  -- 1. Tabula rasa degli autocomandi associati unicamente a questo buffer
  vim.api.nvim_clear_autocmds({ group = puml_group, buffer = current_buf })

  -- 2. Intercettazione e terminazione del processo imv associato
  local job_id = vim.b[current_buf].plantuml_imv_job_id
  if job_id and job_id > 0 then
    vim.fn.jobstop(job_id)
  end

  -- 3. Reset dello stato del buffer
  vim.b[current_buf].plantuml_preview_active = false
  vim.b[current_buf].plantuml_imv_job_id = nil

  vim.notify("PlantUML: Sessione di preview interrotta. Autocompilazione disarmata.", vim.log.levels.INFO)
end

-- Registrazione delle entrypoint CLI in Neovim
vim.api.nvim_create_user_command("PumlImv", function()
  -- Formato raster PNG, imv avviato con configurazione di background nativa
  bootstrap_preview("png", {})
end, { desc = "Compila in PNG, avvia imv e attiva l'autocompilazione al salvataggio" })

vim.api.nvim_create_user_command("PumlImvSvg", function()
  -- Formato vettoriale SVG, imv avviato forzando lo sfondo bianco esadecimale
  bootstrap_preview("svg", { "-b", "ffffff" })
end, { desc = "Compila in SVG, avvia imv con sfondo bianco e attiva l'autocompilazione al salvataggio" })

vim.api.nvim_create_user_command("PumlImvStop", stop_preview,
  { desc = "Sgancia i listener di salvataggio e chiude l'istanza imv associata" })
