{
  config,
  pkgs,
  root,
  lib,
  ...
}: let
  cfg = config.modules.apps.ghostty;
in {
  options.modules.apps.ghostty = {
    enable = lib.mkEnableOption "Enable ghostty";
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package = pkgs.ghostty;

      # enableFishIntegration = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      settings = {
        theme = "Catppuccin Mocha";
        font-family = "SFMono";
        font-size = 16;
        macos-titlebar-style = "hidden";
        window-decoration = false;
        macos-non-native-fullscreen = true;
        quit-after-last-window-closed = lib.mkIf pkgs.stdenv.isDarwin true;
        fullscreen =
          if pkgs.stdenv.isDarwin
          then true
          else false;
      };
    };
  };
}
