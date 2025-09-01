{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.common;
in {
  options.modules.display.enable = lib.mkEnableOption "Enable display";

  config = lib.mkIf cfg.enable {
    modules.hyprland.enable = lib.mkDefault true;
  };
}
