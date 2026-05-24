{
  config,
  pkgs,
  lib,
  ...
}: let
  session = "${pkgs.hyprland}/bin/Hyprland";
  cfg = config.nixos.display;
in {
  options.nixos.display.enable = lib.mkEnableOption "Enable display";

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${session}";
          user = config.settings.username;
        };
        default_session = {
          command = "${session}";
          user = config.settings.username;
        };
      };
    };

    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
