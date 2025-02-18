{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    wsl.url = "github:nix-community/NixOS-WSL/main";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
  let
    globals = rec {
      user = "eddie";
      fullName = "Eddie Cho";
      stateVersion = "24.11";
    };

    supportedSystems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    nixosConfigurations = {
      window = import ./hosts/window { inherit inputs globals; };
    }; 

    homeConfigurations = {
      window = nixosConfigurations.window.config.home-manager.users.${globals.user}.home;
    };
  };
}
