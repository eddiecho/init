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

    globals

    ../../modules/common
    ../../modules/nixos
    ../../modules/wsl

    home-manager.nixosModules.home-manager
  ];

  specialArgs = {
    email = "eunseocho@gmail.com";
  };
}
