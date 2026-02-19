{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    programs.vicinae = {
      enable = true;
      package = pkgs.vicinae;
      systemd = {
        enable = true;
        autoStart = true;
      };
    };
  };
}
