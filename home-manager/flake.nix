{
  description = "Home Manager configuration of eddie";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
#    neovim-nightly-overlay = {
#      url = "github:nix-community/neovim-nightly-overlay";
#    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    {
      homeConfigurations = {
        eddie = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };

          # Specify your home configuration modules here, for example,
          modules = [
            ./home.nix
          ];

          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
        "Eddie.Cho" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
          };

          modules = [
            ./work.nix
          ];
        };
      };
    };
}
