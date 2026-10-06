Il dizionario italiano viene scaricato da Nix (vedi `vim-spell-it` in `module.nix`),
perché il repo GitHub di vim non ospita i file `.spl`/`.sug` (danno 404).

Per riscaricare quello inglese:

```bash
curl -L -o en.utf-8.spl https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl
curl -L -o en.utf-8.sug https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.sug
```
