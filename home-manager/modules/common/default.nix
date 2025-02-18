{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    user = lib.mkOption {
      type = lib.types.str;
    };
    fullName = lib.mkOption {
      type = lib.types.str;
    };
    homePath = lib.mkOption {
      type = lib.types.path;
      default = builtins.toPath (
        if pkgs.stdenv.isDarwin then "/Users/${config.user}" else "/home/${config.user}"
      );
    };
    unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
    insecurePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };
  };
  
  config = {
    environment.systemPackages = with pkgs; [
      git
      vim
      wget
      curl
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
	warn-dirty = false
      '';

      gc = {
        automatic = true;
	options = "--delete-older-than 7d";
      };

      settings = {
        auto-optimise-store = lib.mkIf (!pkgs.stdenv.isDarwin) true;
      };
    };

    nixpkgs.config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.unfreePackages;
      permittedInsecurePackages = config.insecurePackages;
    };
  };
}
