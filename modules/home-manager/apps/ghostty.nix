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
        # The catppuccin port sets its own theme. Two definitions make two
        # theme lines in the config.
        theme = lib.mkIf (!config.catppuccin.ghostty.enable) "Catppuccin Mocha";
        font-family = "SFMono";
        font-size = 16;
        macos-titlebar-style = "hidden";
        window-decoration = false;
        macos-non-native-fullscreen = true;
        quit-after-last-window-closed = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin true;
        background-opacity = 0.8;
        fullscreen = pkgs.stdenv.hostPlatform.isDarwin;
        # Hyprland sends Shift+Insert for SUPER+V. Ghostty binds Shift+Insert
        # to the primary selection by default, not to the clipboard.
        keybind = ["shift+insert=paste_from_clipboard"];
        custom-shader = [
          "${root}/static/shaders/bloom.glsl"
          "${root}/static/shaders/smear-cursor.glsl"
        ];
      };
    };
  };
}
