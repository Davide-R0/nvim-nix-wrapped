# Correttori ortografici e grammaticali

Due correttori lavorano insieme sui file typst, markdown, tex, gitcommit e text:

- **Spell nativo** di nvim (`spelllang = it,en`): solo ortografia, in italiano e
  inglese. Una parola è giusta se è in almeno uno dei due dizionari.
- **Harper** (`harper_ls`): grammatica inglese. Con `isolateEnglish` ignora le
  frasi non inglesi; il suo controllo ortografico è spento per non duplicare
  quello di spell.

I dizionari personali sono separati: una parola aggiunta con `zg` non vale per
Harper, e viceversa.

## Spell nativo

Segna le parole sbagliate solo con la sottolineatura, senza messaggio.

| Tasto         | Cosa fa                                                      |
| ------------- | ------------------------------------------------------------ |
| `]s` / `[s`   | Errore successivo / precedente                               |
| `z=`          | Suggerimenti per la parola sotto il cursore                  |
| `1z=`         | Applica subito il primo suggerimento                         |
| `zg`          | Aggiunge la parola al dizionario personale                   |
| `zw`          | Segna la parola come sbagliata                               |
| `zug` / `zuw` | Annulla `zg` / `zw`                                          |
| `zG`          | Aggiunge la parola solo per la sessione corrente             |
| `<C-x>s`      | (insert mode) Suggerimenti per la parola prima del cursore   |
| `<leader>ts`  | Accende/spegne lo spell nel buffer                           |

Dizionario personale: `stdpath("data")/spell/it.utf-8.add`.

## Harper

Gli errori sono diagnostiche LSP.

| Tasto        | Cosa fa                                     |
| ------------ | ------------------------------------------- |
| `]d` / `[d`  | Diagnostica successiva / precedente         |
| `<leader>e`  | Messaggio completo in un popup              |
| `<leader>ca` | Code action (correzioni, dizionario, ignora) |

Code action tipiche:

- la correzione proposta;
- **Add to user dictionary**: dizionario globale
  (`$XDG_CONFIG_HOME/harper-ls/dictionary.txt`);
- **Add to file dictionary**: solo per quel file;
- **Ignore**: ignora quella segnalazione.

## Dizionari

Il dizionario italiano viene scaricato da Nix (vedi `vim-spell-it` in
`module.nix`), perché il repo GitHub di vim non ospita i file `.spl`/`.sug`
(danno 404). Quello inglese è in questa cartella; per riscaricarlo:

```bash
curl -L -o en.utf-8.spl https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.spl
curl -L -o en.utf-8.sug https://ftp.nluug.nl/pub/vim/runtime/spell/en.utf-8.sug
```
