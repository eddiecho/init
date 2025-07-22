{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.apps.direnv;
in {
  options.hm.apps.direnv = {
    enable = lib.mkEnableOption "Enable direnv";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
