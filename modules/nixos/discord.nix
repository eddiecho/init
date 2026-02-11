{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.discord;
in {
  options.nixos.discord = {
    enable = lib.mkEnableOption "Enable discord";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (discord.override {
        withVencord = true;
      })
    ];
  };
}
