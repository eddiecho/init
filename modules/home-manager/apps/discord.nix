{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.apps.discord;
in {
  options.modules.apps.discord = {
    enable = lib.mkEnableOption "Enable discord";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (discord.override {
        withVencord = true;
      })
    ];
  };
}
