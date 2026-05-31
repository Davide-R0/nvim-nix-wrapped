# ❄️ Neovim Configuration (NixCats + Lazy)

This repository contains a reproducible Neovim configuration built using
**nixCats-nvim** and **lazy.nvim**. It is designed to be consumed as a Flake
input by a NixOS system, but can also be tested and built locally.

---

$\hbar\ \frac{1}{2}$

# Per testare in dev

Usare `nix run .` o `nix build .` per testarlo.

Quando fai `nix run .`, Nix scarica i pacchetti nel `/nix/store`. Non "sporcano"
il tuo sistema operativo (non vanno in /usr/bin).

Per pulire da questi pacchetti scaricati: mettere `nix-collect-garbadge -d`
nella cartella di config di nvim e poi se si vuole eliminare la cartella
`result/`

---

# Per fare l'update dei plugins

- Se si è installato tramite overlay in locale:
  1. `nix flake update` nella coartella `.config/nvim`
  2. rebuild globle del sistema
- Se si è aggiunto ad input i un flake:
  1. `nix flake update` in globale (necessario?)
  2. rebuild globale del sistema

---

Le branch servono per modificare impostazioni personali, come ad esempio
obsidian.lua, colorscheme, ecc... e anche ad avere il proprio lock file nel caso
servisse.

---

| tab1 | tab2  |
| ---- | ----- |
| aaa  | bbbbb |

| aaaa   | baas  |      |
| ------ | ----- | ---- |
| ciao   | caisa | casd |
| sadsda |       |      |

```cpp
int main () {
    return 0;
}
```

```rust
fn main -> Result<,> {

}
```

*aaa* **Aaaa** *aa* **AAaa**

- aaa

1. aaa

- [ ] aa
- [x] aa
- [~] aa [[README#Per testare in dev:]] link1 #tag1 #tag1
  [exmp](<README#What this guide covers:>)

---

## 🔄 The Development Workflow

When adding plugins or changing configurations, follow this strict order of
operations to ensure Nix picks up your changes.

### 1. Edit Configuration 🛠️

- **Add Dependencies:** Modify `nvim/flake.nix` if you need to add new plugins
  or external tools to the flake inputs.
- **Configure Neovim:** Modify `nvim/lua/plugins/your-plugin.lua` or other
  configuration files to set up the plugin.

### 2. Stage Changes (Crucial Step) ⚠️

Nix Flakes only see files that are tracked by git. If you do not stage your new
files or changes, Nix will ignore them.

```bash
cd nvim
git add .
```

### 3. Quick Local Verification ⚡

Before updating your entire system, verify that the configuration loads
correctly.

```bash
# Run Neovim directly from the flake source
nix run .

```

*If this works, your configuration is valid.*

---

## 🚀 Applying Changes to NixOS

Once you have verified the config via `nix run .`, you need to update your main
NixOS configuration to use the new commit/hash of this repo.

### Option A: The "Commit" Method

1. Commit and push your changes in this Neovim repository.
2. If your NixOS configuration tracks a branch (e.g., `main`), it will pick up
   the changes automatically on the next generic update.

### Option B: The "Manual Update" Method (Faster/Local)

If you have staged changes (via `git add .`) but haven't committed them yet, or
if you are pointing to a local path:

1. **Update the flake lock:** Tell your system flake to update specifically the
   `nvim-config` input.

```bash
# Replace 'nvim-config' with whatever you named this input in /etc/nixos/flake.nix
sudo nix flake update nvim-config --flake /etc/nixos

```

1. **Rebuild the System:**

```bash
sudo nixos-rebuild switch

```

## 🛠️ Maintenance & Utility

### Testing the Build 🏗️

To check if the derivation builds successfully without running it:

```bash
nix build .
# The output will be linked to ./result

```

### Updating Neovim Dependencies 📦

When you need to update the inputs defined inside the Neovim flake (e.g.,
bumping plugin versions):

```bash
cd nvim
nix flake update
```

### Cleaning Up `lazy.nvim` 🧹

Since we are using Nix, sometimes `lazy.nvim` state or cache can desync or
become cluttered. To reset the state and download fresh copies of plugins (that
aren't managed strictly by Nix):

```bash
rm -rf ~/.local/share/nvim/lazy ~/.local/state/nvim ~/.cache/nvim

```

### What this guide covers

- **Workflow Logic:** It emphasizes the "Edit -> Git Add -> Update Flake ->
  Rebuild" loop.
- **Safety:** It highlights the importance of `git add .` (a common pitfall).
- **Testing:** It provides the `nix run .` command for fast feedback.
- **Maintenance:** It includes the specific cleanup commands for `lazy.nvim`
  paths.

---

## Il flusso di lavoro completo

- Modifichi `nvim/flake.nix` (aggiungi un plugin)
- Modifichi `nvim/lua/plugins/qualcosa.lua` (lo configuri)
- Fondamentale: Vai nella cartella nvim e fai `git add .`
- Spostati nella cartella NixOS principale
- Update del flake principale:
  - O si fa il commit della repo e nix lo riconosce automaticamente al prossimo
    rebuild
  - O si fa l'update manuale dopo una modifica staged (`git add .`)
    `sudo nix flake update nvim-config --flake /etc/nixos`
- Ricompila il sistema `sudo nixos-rebuild switch`

- Per verificare velocemene se le impostazioni di nvim sono a posto usare nella
  cartella .config/nvim: `nix run .` e vedere se va (dopo aver fatto
  `git add .`)

- Per eliminare i plugin scaricati da lazy:
  `rm -rf ~/.local/share/nvim/lazy ~/.local/state/nvim ~/.cache/nvim`

- Quando si aggiunge un input al flake della config: `nix flake update` nella
  dir di config nvim

- per testare nvim: `nix run .` oppure compilarlo in `result/` con `nix build .`
