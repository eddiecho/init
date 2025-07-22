{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    inherit (nixpkgs) lib;
  in
    # rec means recursive struct
    rec {
      lib = import ./lib inputs;
      flattenAttrset = attrs: builtins.foldl' lib.mergeAttrs {} (builtins.attrValues attrs);

      formatter = lib.forAllSystems (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            inherit (lib) overlays;
          };
        in
          pkgs.alejandra
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
    };
}
