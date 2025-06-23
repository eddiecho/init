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

  outputs =
    inputs@{ self, nixpkgs, ... }:

    let
      inherit (nixpkgs) lib;

      globals = {
        user = "eddie";
        fullName = "Eddie Cho";
        stateVersion = "24.11";
      };

    in
    # rec means recursive struct
    rec {

      lib = import ./lib inputs;
      flatenAttrset = attrs: builtins.foldl' lib.mergeAttrs { } (builtins.attrValues attrs);

      formatter = lib.forAllSystems (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            inherit (lib) overlays;
          };
        in
        pkgs.nixfmt-rfc-style
      );

      nixosConfigurations = flattenAttrset (
        builtins.mapAttrs (
          system: hosts:
          builtins.mapAttrs (
            name: module:
            lib.buildNixos {
              inherit system module;
              specialArgs = { };
            }
          ) hosts
        ) lib.linuxHosts
      );

      homeModules = builtins.mapAttrs (
        system: hosts:
        builtins.mapAttrs (
          name: module: (builtins.head (lib.attrsToList module.home-managers.users)).value
        ) hosts
      ) lib.hosts;

      homeConfigurations = builtins.mapAttrs (
        system: hosts:
        builtins.mapAttrs (
          name: module:
          lib.buildHome {
            inherit system module;
            specialArgs = {};
          }
        )
      ) homeModules;

      /*
      # nixos-rebuild switch --flake .#window
      nixosConfigurations = {
        window = import ./hosts/window { inherit inputs globals lib; };
        framework = import ./hosts/framework { inherit inputs globals lib; };
      };

      # nixos-rebuild switch --flake .#work
      darwinConfigurations = {
        work = import ./hosts/work { inherit inputs globals lib; };
      };

      # home-manager switch --flake .#window
      homeConfigurations = {
        window = nixosConfigurations.window.config.home-manager.users.${globals.user}.home;
        work = darwinConfigurations.work.config.home-manager.users.${globals.user}.home;
      };
      */
    };
}
