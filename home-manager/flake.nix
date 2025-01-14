{
  description = "Home Manager configuration of eddie";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    {
      homeConfigurations = {
        eddie = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };

          modules = [
            ./home.nix
          ];

          extraSpecialArgs = {
            email = "eunseocho@gmail.com";
          };
        };
        work = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "aarch64-darwin";
          };

          modules = [
            ./work.nix
          ];

          extraSpecialArgs = {
            email = "eddie.cho@rubrik.com";
          };
        };
      };
    };
}
