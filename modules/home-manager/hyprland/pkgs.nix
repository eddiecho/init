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
      waybar # status bar
      hyprshot # take screenshots
      hyprlock # lock screen
      hypridle # idle daemon (whatever that means?)
      tofi # popup program switcher
      # hyprpaper # i don't know the difference between this and swww
      swww # wallpaper manager, for loading images because this is hard for some reason????
      linux-wallpaperengine
      swaynotificationcenter # swaync
    ];
  };
}
