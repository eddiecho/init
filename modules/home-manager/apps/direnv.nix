{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.apps.direnv;
in {
  options.modules.apps.direnv = {
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
