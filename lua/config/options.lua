-- Per le funzioni set...=... in .vim
local set = vim.opt

vim.g.mapleader = ' '
-- localleader resta `\`: lo usano i plugin per filetype (es. vimtex `\ll`)
vim.g.maplocalleader = '\\'
-- Spazio da solo non deve spostare il cursore (in normal mode è come `l`)
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Enable executions of local `.nvim.lua`
vim.o.exrc = true

-- per norg
set.conceallevel = 2

-- Controllo ortografico: una parola è giusta se è in almeno uno dei due dizionari.
-- La grammatica inglese la controlla harper_ls (vedi plugins/lsp.lua)
set.spelllang = { 'it', 'en' }
-- Le parole aggiunte con `zg` vanno in stdpath("data"), la config può essere read-only
local spell_dir = vim.fn.stdpath("data") .. "/spell"
if vim.fn.isdirectory(spell_dir) == 0 then
  vim.fn.mkdir(spell_dir, "p")
end
set.spellfile = spell_dir .. "/it.utf-8.add"
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typst", "markdown", "tex", "gitcommit", "text" },
  callback = function()
    vim.opt_local.spell = true
  end,
})
vim.keymap.set("n", "<leader>ts", "<cmd>setlocal spell!<cr>", { desc = "[T]oggle [S]pell" })
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


--vim.env.BROWSER = 'brave'
