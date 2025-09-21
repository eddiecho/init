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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs) lib;
  in rec {
    lib = import ./lib inputs;
    flattenAttrset = attrs: builtins.foldl' lib.mergeAttrs {} (builtins.attrValues attrs);

    formatter = lib.forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        pkgs.alejandra
    );

    packages = lib.forAllSystems (
      system:
        lib.pkgsBySystem.${system}.eddie
    );

    nixosConfigurations = flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildNixos {
                inherit system module;
                specialArgs = {
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
            name: module: (builtins.head (lib.attrsToList module.home-manager.users)).value
          )
          hosts
      )
      lib.hosts;

    homeConfigurations = flattenAttrset (
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

    darwinConfigurations = flattenAttrset (
      builtins.mapAttrs (
        system: hosts:
          builtins.mapAttrs (
            name: module:
              lib.buildDarwin {
                inherit system module;
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
