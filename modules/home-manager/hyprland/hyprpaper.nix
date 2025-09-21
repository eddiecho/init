{
  config,
  lib,
  pkgs,
  ...
}: {
  services.hyprpaper = {
    enable = false;
    settings = {
      preload = [];
      wallpaper = [];
    };
  };
}
