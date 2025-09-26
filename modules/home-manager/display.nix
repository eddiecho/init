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
    home.packages = with pkgs; [
      firefox
    ];
  };
}
