{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
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

    hyprland.url = "github:hyprwm/Hyprland";

    ghostty.url = "github:ghostty-org/ghostty";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sfmono = {
      url = "path:./static/fonts/SFMono";
      flake = false;
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixos-hardware,
    treefmt-nix,
    ...
  }: let
    vals = builtins.fromJSON (builtins.readFile ./config.json);
  in rec {
    lib = import ./lib inputs;

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
                  inherit nixos-hardware;
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
                inherit system module vals;
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
                inherit system module vals;
                specialArgs = {
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
