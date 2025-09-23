{
  config,
  pkgs,
  lib,
  ...
}: let
  tuigreet = "${pkgs.greetd.tuigreet}/bin/tuigreet";
  session = "${pkgs.hyprland}/bin/Hyprland";
  cfg = config.nixos.display;
in {
  options.nixos.display.enable = lib.mkEnableOption "Enable display";

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
    };

    /*
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.sddm.wayland.enable = true;
    */

    services.greetd = {
      enable = true;
      settings = {
        initial_session = {
	  command = "${session}";
	  user = "eddie";
	};
	default_session = {
	  command = "${session}";
	  user = "eddie";
	};
      };
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
