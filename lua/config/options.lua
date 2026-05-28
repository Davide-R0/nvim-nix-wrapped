-- Per le funzioni set...=... in .vim
local set = vim.opt

vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- per norg
set.conceallevel = 2

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
--local undodir = vim.fn.stdpath("state") .. "/undo" --~/.local/state/nvim/undo
--if vim.fn.isdirectory(undodir) == 0 then
--  vim.fn.mkdir(undodir, "p")
--end
--set.undodir = undodir
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

--Set Encoding -- dovrebeb averlo di default
--set.encoding = "utf-8"

-- Search hilighting
set.hlsearch = false
set.incsearch = true

-- Error flash instead of sound
set.visualbell = true

-- Enable true color (optional)
set.termguicolors = true

--Scrolling setting
set.scrolloff = 10         --lascia sempre un offset di righe
vim.opt.signcolumn = "yes" --Attivazione barra sinistra per gli errori e vari (magari non necessaio)

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
