{
  config,
  root,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      enable = true;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      size = 24;
    };

    home.file = {
      ".config/hypr/parts" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          (builtins.toPath "${root}/static/hypr/parts");
      };
      ".config/hypr/host.lua".text = "return ${lib.generators.toLua {} {inherit (cfg) scale;}}\n";
    };

    home.sessionVariables = {
      HYPRCURSOR_SIZE = "24";
      AQ_NO_MODIFIERS = "1";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      configType = "lua";

      # I don't know why I need this
      extraConfig = ''
        require("parts")
      '';
    };
  };
}
