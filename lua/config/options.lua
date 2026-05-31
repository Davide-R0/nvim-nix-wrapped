-- Per le funzioni set...=... in .vim
local set = vim.opt

vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

-- per norg
set.conceallevel = 2

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
set.expandtab = true

-- Reload files changed outside nvim
set.autoread = true

-- Search hilighting
set.hlsearch = false
set.incsearch = true

-- Error flash instead of sound
set.visualbell = true

-- Enable true color (optional)
set.termguicolors = true

--Scrolling setting
set.scrolloff = 10
vim.opt.signcolumn = "yes"

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
vim.scrolloff = 3

--Deactivate perl provider
vim.g['loaded_perl_provider'] = 0
--Deactivate ruby provider
vim.g['loaded_ruby_provider'] = 0
