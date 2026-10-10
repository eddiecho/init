{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprland
      xwayland
      xrdb # load ~/.Xresources into XWayland
      waybar # status bar
      hyprshot # take screenshots
      hyprlock # lock screen
      hypridle # idle daemon (whatever that means?)
      linux-wallpaperengine
      steamcmd # for wallpaper engine assets
      swaynotificationcenter # swaync
      vicinae # command pallete
    ];
  };
}
