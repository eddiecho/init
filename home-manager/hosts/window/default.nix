# System config for WSL based systems

{ inputs, globals, ... }:

with inputs;

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    # god nix is so ASS
    (
      { config, ... }:
      {
        config._module.args = { inherit inputs globals; };
      }
    )

    (
      globals
      // {
        gitEmail = "eunseocho@gmail.com";
      }
    )

    ../../modules/common
    ../../modules/nixos
    ../../modules/wsl

    wsl.nixosModules.default

    home-manager.nixosModules.home-manager

    {
      wsl.enable = true;
      wsl.defaultUser = globals.user;
    }
  ];

  specialArgs = {
    email = "eunseocho@gmail.com";
  };
}
