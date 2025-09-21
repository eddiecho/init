{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.display;
in {
  options.nixos.display.enable = lib.mkEnableOption "Enable display";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      ghostty
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
