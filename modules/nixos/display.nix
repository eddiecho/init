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
      settings = let
        # greetd execs `command` directly with no shell in between, so
        # home.sessionVariables (XCURSOR_THEME/SIZE, EDITOR, ...) never
        # reach Hyprland or anything it spawns unless we route through a
        # login shell ourselves — `-l` makes zsh read ~/.zprofile, which is
        # what home-manager's zsh integration uses to export them.
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
