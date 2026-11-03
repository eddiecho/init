{
  config,
  pkgs,
  lib,
  ...
}: let
  session = "${config.programs.hyprland.package}/bin/start-hyprland";
  cfg = config.nixos.display;
in {
  options.nixos.display.enable = lib.mkEnableOption "Enable display";

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = let
        # or this
        loginSession = "${pkgs.zsh}/bin/zsh -l -c 'exec ${session}'";
      in {
        initial_session = {
          command = loginSession;
          user = config.settings.username;
        };
        default_session = {
          command = loginSession;
          user = config.settings.username;
        };
      };
    };

    programs.hyprland = {
      enable = true;
      # The module overrides the package with this value. The nixpkgs default is true.
      # A false value gives a build that cache.nixos.org does not have.
      withUWSM = true;
    };

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
