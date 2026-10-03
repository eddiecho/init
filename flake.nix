{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    determinate = {
      url = "github:DeterminateSystems/determinate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-locate
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sfmono = {
      url = "path:./static/fonts/SFMono";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    nixos-hardware = inputs.nixos-hardware;
    vals = builtins.fromJSON (builtins.readFile ./config.json);
    lib = import ./lib inputs;
  in {
    devShells = lib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            direnv
            just
            git-lfs
            jq
          ];
        };
      }
    );

    formatter = lib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper
    );

    tools = lib.forAllSystems (
      system:
        lib.pkgsBySystem.${system}.tools
    );

    nixosConfigurations = lib.flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildNixos {
                inherit system;
                modules = [
                  module
                  inputs.home-manager.nixosModules.home-manager
                  inputs.wsl.nixosModules.wsl
                  inputs.determinate.nixosModules.default
                  inputs.catppuccin.nixosModules.catppuccin
                  inputs.nix-index-database.nixosModules.default
                  inputs.disko.nixosModules.disko
                  {
                    programs.nix-index-database.comma.enable = true;
                    environment.sessionVariables = {
                      NIXOS_FLAKE_NAME = name;
                      LESS = "-X -F -R";
                    };
                  }
                ];
                specialArgs = {
                  inherit nixos-hardware vals;
                  root = self;
                };
              }
          )
          hosts
      )
      lib.linuxHosts
    );

    # see hosts/home/README.md for what this
    homeConfigurations = lib.flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildHome {
                inherit system;
                modules = [
                  module
                ];
                specialArgs = {
                  inherit vals;
                  root = self;
                };
              }
          )
          hosts
      )
      lib.homeHosts
    );

    darwinConfigurations = lib.flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildDarwin {
                inherit system;
                modules = [
                  module
                  inputs.home-manager.darwinModules.home-manager
                  {
                    environment.variables = {
                      NIXOS_FLAKE_NAME = name;
                    };
                  }
                ];
                specialArgs = {
                  inherit vals;
                  root = self;
                };
              }
          )
          hosts
      )
      lib.darwinHosts
    );
  };
}
