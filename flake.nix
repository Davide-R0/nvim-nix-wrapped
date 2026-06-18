{
  description = "Flake exporting a configured neovim package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };

    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };

    # Per renderizzare in uft-8 le formule latex in markdown
    libtexprintf = {
      url = "github:xbwwj/libtexprintf-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      wrappers,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ wrappers.flakeModules.wrappers ];
      systems = nixpkgs.lib.platforms.all;

      perSystem =
        { config, ... }:
        {
          packages.default = config.packages.neovim;
        };

      flake = {
        wrappers.neovim = nixpkgs.lib.modules.importApply ./module.nix inputs;

        nixosModules = {
          neovim = wrappers.lib.getInstallModule {
            name = "neovim";
            value = self.wrapperModules.neovim;
          };
          default = self.nixosModules.neovim;
        };

        homeModules = {
          neovim = wrappers.lib.getInstallModule {
            name = "neovim";
            value = self.wrapperModules.neovim;
          };
          default = self.homeModules.neovim;
        };

        overlays = {
          neovim = final: _: { neovim = self.wrappers.neovim.wrap { pkgs = final; }; };
          default = self.overlays.neovim;
        };
      };
    };
}
