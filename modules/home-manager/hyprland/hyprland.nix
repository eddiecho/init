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

    # XWayland apps render at scale 1 (xwayland.force_zero_scaling in settings.lua).
    # Steam and other X apps read Xft.dpi to scale their own UI.
    xresources.properties = lib.mkIf (cfg.scale != 1) {
      "Xft.dpi" = builtins.floor (96 * cfg.scale + 0.5);
    };

    # Home-manager only loads ~/.Xresources in an X11 session (xsession).
    # graphical-session.target starts after Hyprland imports DISPLAY into systemd.
    systemd.user.services.xrdb = lib.mkIf (cfg.scale != 1) {
      Unit = {
        Description = "Load ~/.Xresources into XWayland";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.xrdb}/bin/xrdb -merge ${config.xresources.path}";
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install.WantedBy = ["graphical-session.target"];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        # Apps launched from vicinae are children of a systemd user service.
        # Import all session variables so that these apps get them.
        variables = ["--all"];
      };
      configType = "lua";

      # I don't know why I need this
      extraConfig = ''
        require("parts")
      '';
    };
  };
}
