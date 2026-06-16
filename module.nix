inputs:
{
  config,
  wlib,
  lib,
  pkgs,
  options,
  ...
}:
{
  imports = [ wlib.wrapperModules.neovim ];

  options = {
    settings = {
      neorg.enable = lib.mkEnableOption "Enable Neorg plugin";

      ai.enable = lib.mkEnableOption "Enable AI plugin (CodeCompanion)";

      obsidian.enable = lib.mkEnableOption "Enable Obsidian plugin";
      conform.md_line_length = lib.mkOption {
        type = lib.types.int;
        default = 80;
        description = "Max line length for markdown formatting";
      };

      # Inform our lua of which top level specs are enabled
      cats = lib.mkOption {
        readOnly = true;
        type = lib.types.attrsOf lib.types.bool;
        default = builtins.mapAttrs (_: v: v.enable) config.specs;
      };
    };

    nvim-lib = {
      neovimPlugins = lib.mkOption {
        readOnly = true;
        type = lib.types.attrsOf wlib.types.stringable;
        # Makes plugins autobuilt from our inputs available with
        # `config.nvim-lib.neovimPlugins.<name_without_prefix>`
        default = config.nvim-lib.pluginsFromPrefix "plugins-" inputs;
      };
      # build plugins from inputs set
      pluginsFromPrefix = lib.mkOption {
        type = lib.types.raw;
        readOnly = true;
        default =
          prefix: inputs:
          lib.pipe inputs [
            builtins.attrNames
            (builtins.filter (s: lib.hasPrefix prefix s))
            (map (
              input:
              let
                name = lib.removePrefix prefix input;
              in
              {
                inherit name;
                value = config.nvim-lib.mkPlugin name inputs.${input};
              }
            ))
            builtins.listToAttrs
          ];
      };
    };
  };

  config = {
    settings = {
      config_directory = ./.; # Directory for your config.
      neorg.enable = lib.mkDefault true;
      ai.enable = lib.mkDefault true;
      obsidian.enable = lib.mkDefault true;
    };

    specs = {
      neorg = {
        enable = config.settings.neorg.enable;
        lazy = true;
        data = with pkgs.vimPlugins; [
          neorg
          neorg-telescope
        ];
      };

      ai = {
        enable = config.settings.ai.enable;
        lazy = true;
        data = with pkgs.vimPlugins; [
          codecompanion-nvim
        ];
      };

      obsidian = {
        enable = config.settings.obsidian.enable;
        lazy = true;
        data = with pkgs.vimPlugins; [
          obsidian-nvim
        ];
      };

      lsp = {
        data = with pkgs.vimPlugins; [
          # TODO: cambairlo e metterlo nei plugin generali??
          nvim-lspconfig
        ];
      };

      lze = [
        config.nvim-lib.neovimPlugins.lze
        {
          data = config.nvim-lib.neovimPlugins.lzextras;
          name = "lzextras";
        }
      ];

      general = {
        after = [ "lze" ];
        runtimePkgs = with pkgs; [
          # TODO: quali di questi non sono strettamente necessari o andrebbero isntalalrti dall host che lo usa?
          tree-sitter
          prettier # code formatter (for conform-nvim)
          # manual for nix options
          manix # TODO: rimuoverlo...
          # For latex
          inputs.libtexprintf.packages.${pkgs.system}.default # per renderizzare le formule di latex nei file md
          #texlive.combined.scheme-full # O scheme-medium (Il compilatore LaTeX)
          zathura # Il visualizzatore PDF
          xdotool # FONDAMENTALE: serve a VimTeX per comunicare con Zathura
          resvg # rendering svg
          # PlantUML
          plantuml-c4
          #jre
          graphviz
          imv
          # ====================
          # LSP
          # ====================
          # Lua
          lua-language-server
          stylua
          # Nix
          nixd
          nixfmt
          # C / C++
          clang-tools
          cmake-language-server
          # Rust overlay
          #(rust-bin.stable.latest.default.override {
          #  extensions = [
          #    "rust-src"
          #    "rust-analyzer"
          #  ];
          #})
          # Web (HTML/CSS/JS/TS)
          vscode-langservers-extracted # Fornisce html, css, json
          typescript-language-server
          bash-language-server
          # Python
          basedpyright
          # Latex
          texlab
          texlivePackages.latexindent
          # Markdown
          markdown-oxide
          # Openscad
          openscad-lsp
          # Hardware / Low level
          arduino-language-server
          asm-lsp
          # toml files
          taplo
          # Asm
          asm-lsp
          asmfmt
          # For telescope
          ripgrep
          fd
          # For git
          git
          lazygit
          # For typst
          typst
          tinymist # typst lsp
          # Lean # NOTE: After the first installation: `elan default stable`
          elan
          # For images, pdf, videos, ecc...
          chafa
          ueberzugpp
          imagemagick
          ffmpegthumbnailer # Opzionale per video
          poppler-utils # Opzionale per PDF
          # For startup page
          fortune
          cowsay
          # General
          wget
          curl
          gnumake
          gcc
          #################
          # Linters
          #################
          # Rust, lean4, hanno linter integrati
          # --- Markdown ---
          markdownlint-cli2 # Comando: markdownlint
          # --- C / C++ ---
          cppcheck # Analisi statica
          # Nota: Spesso per C/C++ si usa clang-tidy (incluso in llvmPackages.clang-unwrapped o simili)
          # --- Bash ---
          shellcheck # Lo standard per bash
          # --- Lua ---
          selene # Linter moderno per Lua (alternativa a luacheck)
          # --- Python ---
          python3Packages.ruff
          #python311Packages.flake8 # less powerfull linter
          # --- Nix ---
          statix # Linter specifico per trovare anti-pattern in Nix
          deadnix # Trova codice Nix non utilizzato
          # --- Latex ---
          #chktex   # Dovrebbe essere già dentro il pachcetto texlive
          # --- Altri utili ---
          harper # linter per la lingua in rust
          #ltex-ls # Linter per la lingua
          #vale                   # Linter per la prosa (inglese) molto potente
          #hunspell          # Motore per il controllo ortografico
          #hunspellDicts.it_IT # Dizionario italiano
          #hunspellDicts.en_US # Dizionario inglese
        ];
        # this `lazy = true` definition will transfer to specs in the contained DAL, if there is one.
        # This is because the definition of lazy in `config.specMods` checks `parentSpec.lazy or false`
        # the submodule type for `config.specMods` gets `parentSpec` as a `specialArg`.
        # you can define options like this too!
        lazy = true;

        data = with pkgs.vimPlugins; [
          {
            data = vim-sleuth;
            # You can override defaults from the parent spec here
            lazy = false;
          }
          # for dms automatic color creation
          base16-nvim
          # General
          lualine-nvim # Lualine
          alpha-nvim # Startup page
          oil-nvim # Filemanager
          fidget-nvim # Notifications
          lazydev-nvim # lua lsp for nvim configurations
          todo-comments-nvim # Todo comments
          nvim-spectre # for searching in multiple files
          popup-nvim # for extra window managment
          undotree # undotree
          image-nvim # Images
          nvim-web-devicons # For special icons (Lualine, Telescope, Oil, ...)
          nvim-autopairs # autopairs
          nvim-colorizer-lua # for colors in #ffffff
          #vim-table-mode # md table formatting # NOTE: trovarne un altro con licenza
          csvview-nvim # csv viewer
          actions-preview-nvim # Actions preview
          fzf-vim
          conform-nvim # text formatter
          # PlantUML
          plantuml-syntax
          # Typst preview
          typst-preview-nvim
          calendar-vim
          # Speller
          #vim-spell-it  # manual
          #vim-spell-en
          # Linter
          nvim-lint
          # Git
          lazygit-nvim # TODO: da mettere in gitPlugins ?
          diffview-nvim
          vim-fugitive # NOTE: da togliere?
          gitsigns-nvim
          # Lean
          lean-nvim
          # Agda
          cornelis
          nvim-hs-vim
          vim-textobj-user
          # For rust Cargo.toml files
          crates-nvim
          # Telescope
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim
          telescope-file-browser-nvim
          telescope-media-files-nvim
          plenary-nvim
          telescope-manix
          # Lsp
          openscad-nvim
          #idris2-nvim
          # Autocomplition
          nvim-cmp
          cmp_luasnip
          cmp-nvim-lsp
          cmp-path
          cmp-buffer
          cmp-cmdline
          luasnip
          friendly-snippets
          # Markdown
          render-markdown-nvim
          markdown-preview-nvim
          # Latex watching
          vimtex
          # Treesitter
          nvim-treesitter.withAllGrammars
          nvim-treesitter-parsers.markdown_inline
        ];
      };
    };

    # This submodule modifies both levels of your specs
    # NOTE: non ho capisto cosa sia questa opzione? a che serve?
    specMods =
      {
        # When this module is ran in an inner list,
        # this will contain `config` of the parent spec
        parentSpec ? null,
        # and this will contain `options`
        # otherwise they will be `null`
        parentOpts ? null,
        parentName ? null,
        # and then config from this one, as normal
        config,
        # and the other module arguments.
        ...
      }:
      {
        # you could use this to change defaults for the specs
        # config.collateGrammars = lib.mkDefault (parentSpec.collateGrammars or false);
        # config.autoconfig = lib.mkDefault (parentSpec.autoconfig or false);
        # config.runtimeDeps = lib.mkDefault (parentSpec.runtimeDeps or false);
        # config.pluginDeps = lib.mkDefault (parentSpec.pluginDeps or false);
        # or something more interesting like:
        # add a runtimePkgs field to the specs themselves
        options.runtimePkgs = options.runtimePkgs // {
          description = ''
            A runtimePkgs spec field to put packages on the PATH
            If the spec is disabled, this value will not be included in the resulting neovim derivation
          '';
        };
        # You could do this too
        # config.before = lib.mkDefault [ "INIT_MAIN" ];
      };

    runtimePkgs = config.specCollect (acc: v: acc ++ (v.runtimePkgs or [ ])) [ ];
  };
}
