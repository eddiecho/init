# System config for WSL based systems

{ inputs, globals, ... }:

with inputs;

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  modules = [
    ../../modules/common

    wsl.nixosModules.default
    {
      system.stateVersion = globals.stateVersion;
      wsl.enable = true;
      wsl.defaultUser = globals.user;
    }

    home-manager.nixosModules.home-manager
  ];

  specialArgs = {
    email = "eunseocho@gmail.com";
  };
}
