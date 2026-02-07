{
  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      #url = "github:nix-community/home-manager";
      url = "https://flakehub.com/f/nix-community/home-manager/0.2511.5858";
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
      # that version has to track stateVersion
      url = "github:catppuccin/nix/release-25.11";
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
    nixos-hardware,
    treefmt-nix,
    determinate,
    catppuccin,
    ...
  }: let
    vals = builtins.fromJSON (builtins.readFile ./config.json);
    lib = import ./lib inputs;
  in rec {
    devShell = lib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            direnv
            gnumake
          ];
        }
    );

    formatter = lib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.wrapper
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
                inherit name system module;
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

    homeModules =
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              (builtins.head (lib.attrsToList
                (module {
                  # ensure compatibility with the actual module
                  inherit nixos-hardware vals;
                  pkgs = nixpkgs.legacyPackages.${system};
                }).home-manager.users)).value
          )
          hosts
      )
      lib.hosts;

    homeConfigurations = lib.flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildHome {
                inherit system module;
                specialArgs = {
                  root = self;
                };
              }
          )
          hosts
      )
      homeModules
    );

    darwinConfigurations = lib.flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildDarwin {
                inherit name system module;
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
