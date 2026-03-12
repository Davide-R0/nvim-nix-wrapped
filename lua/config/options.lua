-- Per le funzioni set...=... in .vim
local set = vim.opt


-- Enable mouse mode, can be useful for resizing splits for example!
--vim.opt.mouse = 'a'
--
---- Attiva il controllo ortografico
--vim.opt.spell = true
---- Imposta le lingue (Italiano come principale, Inglese come secondario)
---- Neovim cercherà di capire quale usare o le userà entrambe
--vim.opt.spelllang = { 'it', 'en' }
---- Dove salvare le parole che aggiungi (con 'zg')
---- La cartella deve esistere!
--local spell_dir = vim.fn.stdpath("config") .. "/spell"
--if vim.fn.isdirectory(spell_dir) == 0 then
--  vim.fn.mkdir(spell_dir, "p")
--end
---- Definisce il file del dizionario personale
--vim.opt.spellfile = spell_dir .. "/it.utf-8.add"
--vim.keymap.set("n", "z=", function()
--  require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({
--    previewer = false,
--    layout_config = {
--      width = 0.3,
--      height = 0.4,
--    }
--  }))
--end, { desc = "Suggerimenti Ortografici" })

-- This is necessary to make nvim expand the bash aliases when it execute commands
vim.o.shell = "bash"
vim.o.shellcmdflag = "-c"

-- On saving files
set.backup = false
set.swapfile = false
-- Undo save
local undodir = vim.fn.stdpath("state") .. "/undo" --~/.local/state/nvim/undo
if vim.fn.isdirectory(undodir) == 0 then
  vim.fn.mkdir(undodir, "p")
end
set.undodir = undodir
set.undofile = true

-- for obsidian preview
--set.conceallevel = 1

-- Number line option
set.nu = true
set.relativenumber = true
set.number = true

-- Set the behavior of tab
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.expandtab = true --per avere solo spazi e non tab

-- Reload files changed outside nvim
set.autoread = true

--Set Encoding
set.encoding = "utf-8"

-- Search hilighting
set.hlsearch = false
set.incsearch = true

-- Error flash instead of sound
set.visualbell = true

-- Enable true color (optional)
set.termguicolors = true

--Scrolling setting
set.scrolloff = 7     --lascia sempre un offset di righe
vim.signcolumn = true --Attivazione barra sinistra per gli errori e vari (magari non necessaio)

-- Setting backspace key like delite
--set.backspace = "indent", "eol", "start"

-- Autoindentation
set.autoindent = true

-- Set status line to visualize the modes
-- Hide insert, normal, visual status mode
set.showmode = false
set.showcmd = true

-- Hilight matching parentesis..
set.showmatch = true

-- clipboard initialization
set.clipboard = "unnamedplus"

-- Enable standard hilighting of text
vim.syntax = "on"

-- Folding method
vim.foldmethod = "indent"
vim.foldnestmax = 1
vim.foldlevelstart = 1

-- Set scrool number line
--vim.scrolloff = 2

---- Standard setup ----

-- Set Python directory
-- analogo ad let g:... = /...
-- TODO:
--vim.g['python3_host_prog'] = "/usr/bin/python3"

--Deactivate perl provider
vim.g['loaded_perl_provider'] = 0
--Deactivate ruby provider
vim.g['loaded_ruby_provider'] = 0

-- Terminal
-- TODO: Ricontrollare
vim.cmd [[
let term_program=$TERM_PROGRAM
]]

-- glsl hiligting
vim.cmd [[
autocmd! BufNewFile,BufRead *.vs,*.fs,*.cp,*.vert,*.frag,*.comp set ft=glsl
]]

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
      "author: [Author1, Author2]",
      "lang: it-IT",
      "tags: []",
      "draft: false",
      "# ------setings------- #",
      "geometry: \"a4paper, left=2cm, right=2cm, top=3cm, bottom=3cm\"",
      "mainfont: \"CMU Bright\"",
      "monofont: \"NotoSansMono\"",
      "fontsize: 11pt",
      "numbersections: true",
      "toc-own-page: true",
      "toc-depth: 4",
      "listings-disable-line-numbers: false",
      "listings-no-page-break: true",
      "table-use-row-colors: true",
      "# ------commands------- #",
      "# \\maketitle \\tableofcontents \\newpage",
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
    "pandoc --template=%s -H %s --listings --pdf-engine=lualatex  %s -o %s", -- -L %s resource-path=%s
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
