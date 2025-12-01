{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.steam;
in {
  options.nixos.steam = {
    enable = lib.mkEnableOption "Enable steam";
  };

  config = lib.mkIf (cfg.enable && config.nixos.display.enable) {
    programs.steam.enable = true;
  };
}
