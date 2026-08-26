{
  inputs = {
    # nixos-unstable currently rolls into the 26.05 release ("Yarara",
    # expected end of May 2026). Once 26.05 ships, switching this to
    # `nixos-26.05` would pin to the stable release branch.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    determinate = {
      url = "github:DeterminateSystems/determinate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      # No nix-darwin-26.05 branch yet; track master until it lands.
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      # On github (not flakehub) so we get the `configType = "lua"` option
      # for hyprland, which flakehub releases lag behind on.
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/nur";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      # Tracks main until a release-26.05 branch exists; bump to that
      # branch once nixpkgs is also pinned to nixos-26.05.
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
  in rec {
    devShells = lib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            direnv
            gnumake
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

    # Standalone home-manager configs for machines with no NixOS/nix-darwin
    # system config of their own — see hosts/home/README.md for what this
    # is for and how to run it. Sourced from hosts/home/, never from the
    # same hosts/<system>/<name> tree that nixosConfigurations/
    # darwinConfigurations use, so a name here can't collide with an
    # already system-managed host.
    homeConfigurations = lib.flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildHome {
                inherit system;
                modules = [
                  inputs.catppuccin.homeModules.catppuccin
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
