{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = false;
      settings = {
        preload = [];
        wallpaper = [];
      };
    };
  };
}
