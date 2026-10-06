# CLAUDE.md

Guida per lavorare in questa repository. Configurazione
**Neovim** impacchettata tramite **Nix** (flake) usando i moduli
`nix-wrapper-modules` di BirdeeHub e il plugin-loader **`lze`** /
**`lzextras`**.

## Cos'è questo progetto

Non è una config Neovim "classica" da mettere in
`~/.config/nvim`: è un **flake Nix** che produce un pacchetto
`neovim` autocontenuto (con plugin, LSP server, linter e tool CLI
già sul `PATH`). La config Lua vive dentro la repo e viene
iniettata nel wrapper.

- `flake.nix` — definisce inputs (nixpkgs, wrappers, lze,
  lzextras, libtexprintf) e outputs (`packages.default`, moduli
  NixOS/Home-Manager, overlay).
- `module.nix` — il cuore Nix: dichiara le `options.settings`
  (feature flags) e le `specs`, cioè i gruppi di
  plugin/pacchetti. Qui si aggiungono plugin Nix, LSP server
  (`runtimePkgs` della spec `general`) e linter.
- `init.lua` — bootstrap: configura `lze`, registra gli handler
  custom (`auto_enable`, `for_cat`), carica `config.*` e poi
  tutte le spec dei plugin da `lua/plugins/` via
  `mod_dir_to_spec`.

### Flusso di caricamento (init.lua)

1. Espone `_G.nixInfo` (ponte fra Lua e le info Nix;
   `nixInfo.isNix` dice se siamo dentro il wrapper).
2. Registra gli handler `lze`:
   - `auto_enable` — abilita il plugin solo se il pacchetto Nix
     corrispondente esiste.
   - `for_cat` — abilita in base a `settings.cats.<nome>` (i
     feature flag di `module.nix`, es. `ai`, `obsidian`,
     `neorg`).
3. `require("config.options" | "config.keymaps" | "config.commands")`.
4. Raccoglie le spec da `lua/plugins/*.lua` (escluso
   `dankcolors.lua`, gestito a parte con conversione al volo) e
   le passa a `nixInfo.lze.load(specs)`.
5. `require("config.transparency")`.

## Struttura file

```
init.lua                     # bootstrap lze + caricamento spec
flake.nix / module.nix       # packaging Nix, feature flags, elenco plugin+tool
lua/config/
  options.lua                # vim.opt / vim.g globali. leader = '\'
  keymaps.lua                # keymap globali (attualmente quasi vuoto)
  commands.lua               # user command (:Pprint, :MdToPdf, :Puml*, ...), autocmd FileType
  ocp_preview.lua            # preview build123d/OCP (setup() chiamato da commands.lua)
  transparency.lua           # sfondo trasparente
lua/plugins/
  00_general.lua             # ~30 plugin "utility" in un unico file (surround, spectre, git, ...)
  <plugin>.lua               # una spec (o lista di spec) per file
docs/                        # esempi/asset (test.md, .puml, .svg, ...)
spell/                       # dizionari it/en
```

## Convenzioni delle spec plugin (`lua/plugins/*.lua`)

Ogni file fa `return { ... }` con una spec `lze` o una lista di
spec. Campi ricorrenti:

- `"nome-plugin"` — primo elemento posizionale, il nome del
  plugin Nix.
- `enabled`, `lazy` — booleani standard.
- `auto_enable` — handler custom: attiva solo se il plugin è
  presente in Nix.
- `for_cat = "<cat>"` — attiva in base a `settings.cats` (feature
  flag Nix).
- `ft`, `cmd`, `event`, `keys` — trigger di lazy-loading.
- `before` / `after(plugin)` — eseguiti prima/dopo il load; qui
  di solito si chiama `require("<plugin>").setup(plugin.opts)`.
- `opts` — tabella o funzione con la configurazione.

Aggiungere un plugin richiede **due passi**: dichiararlo in
`module.nix` (nella spec `general.data` o in una spec dedicata)
**e** creare/aggiornare la sua spec Lua in `lua/plugins/`.

## Keybindings — leader e mappe visual/x esistenti

`mapleader` e `maplocalleader` sono entrambi **`\`** (backslash),
impostati in `lua/config/options.lua`.

Mappe attive in **visual (`v`) / `x`** — da conoscere per evitare
conflitti:

| Tasto                                         | Modo | Fonte                    | Azione                  |
| --------------------------------------------- | ---- | ------------------------ | ----------------------- |
| `<C-s>`                                       | n, v | codecompanion.lua        | CodeCompanion Actions   |
| `<leader>a` (`\a`)                            | n, v | codecompanion.lua        | Toggle chat AI          |
| `ga`                                          | v    | codecompanion.lua        | Add to CodeCompanion    |
| `<leader>ca` (`\ca`)                          | v, n | 00_general.lua           | Code Actions preview    |
| `<leader>sw` (`\sw`)                          | v    | 00_general.lua           | Spectre search word     |
| `<leader>ol` (`\ol`)                          | v    | obsidian.lua             | Link selezione          |
| `<leader>onl` (`\onl`)                        | v    | obsidian.lua             | Nuova nota da selezione |
| `if` / `af`                                   | o, x | 00_general.lua (csvview) | textobject campo CSV    |
| `<Tab>` / `<S-Tab>` / `<Enter>` / `<S-Enter>` | n, v | 00_general.lua (csvview) | navigazione CSV         |
| `am` `im` `ac` `ic` `as`                      | x, o | treesitter.lua           | textobject treesitter   |

`nvim-surround` è presente (00_general.lua) e fornisce le sue
mappe visual standard (`S`) per racchiudere una selezione.

### Convenzione per keymap markdown-specifici

Per limitare una mappa ai soli buffer markdown si usa un autocmd
`FileType markdown` con
`vim.keymap.set(..., { buffer = args.buf })`, così non tocca gli
altri filetype e non entra in conflitto globale.

## Feature flags (module.nix → settings.cats)

- `neorg.enable`, `ai.enable`, `obsidian.enable` — default
  `true`.
- `conform.md_line_length` — larghezza wrapping markdown (default
  80).
- `render-backend` — `kitty` (default) o `ueberzug` per le
  immagini.

## Comandi utente notevoli (commands.lua)

- `:Pprint` / `:PprintMdPdf` — stampa file / MD→PDF via
  pandoc+lp.
- `:MdToPdf`, `:MdYamlHeader` — compilazione e header YAML
  markdown.
- `:PumlImv[Svg]` / `:PumlImvStop` — preview PlantUML in `imv`
  con ricompilazione al salvataggio.
- `:LzeNix`, `:LzeStatus` — debug plugin Nix/lze.

## Build / test

```sh
nix build            # costruisce il pacchetto neovim
nix run              # avvia il neovim configurato
nix flake check
nix flake update     # aggiorna i lock degli input
```

Formatter/linter Nix disponibili sul PATH del wrapper: `nixfmt`,
`statix`, `deadnix`. Per Lua: `stylua`, `selene` (config in
`selene.toml`).

## Note

- Testo e commenti sono prevalentemente **in italiano**:
  mantenere lo stile.
- `dankcolors.lua` è trattato in modo speciale in `init.lua` (non
  passa per `mod_dir_to_spec`): convertito al volo (`config` →
  `after`, rinomina pacchetto).
- `clipboard = unnamedplus`: il registro unnamed è sincronizzato
  con `+`.
