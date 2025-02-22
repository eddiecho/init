{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      globals = {
        user = "eddie";
        fullName = "Eddie Cho";
        stateVersion = "24.11";
      };

      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;

    in
    # rec means recursive struct
    rec {
      formatter = {
        x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
        aarch64-darwin = inputs.nixpkgs.legacyPackages.aarch64-darwin.nixfmt-rfc-style;
      };

      # nixos-rebuild switch --flake .#window
      nixosConfigurations = {
        window = import ./hosts/window { inherit inputs globals; };
        framework = import ./hosts/framework { inherit inputs globals; };
      };

      # nixos-rebuild switch --flake .#work
      darwinConfigurations = {
        work = import ./hosts/work { inherit inputs globals; };
      };

      # home-manager switch --flake .#window
      homeConfigurations = {
        window = nixosConfigurations.window.config.home-manager.users.${globals.user}.home;
        work = darwinConfigurations.work.config.home-manager.users.${globals.user}.home;
      };
    };
}
