{
  config,
  root,
  lib,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    home.file = {
      # ~/.config/hypr/ itself stays HM-owned because the wayland module
      # writes hyprland.conf there (see `systemd.enable = true` below).
      # We symlink only the entrypoint file plus the parts/ subdirectory,
      # so adding/editing files in static/hypr/parts/ takes effect live.
      ".config/hypr/hyprland.lua" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          (builtins.toPath "${root}/static/hypr/hyprland.lua");
      };
      ".config/hypr/parts" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          (builtins.toPath "${root}/static/hypr/parts");
      };
      ".config/hyprland" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          (builtins.toPath "${root}/static/hyprland");
      };
      ".config/wallpapers" = {
        source =
          config.lib.file.mkOutOfStoreSymlink
          (builtins.toPath "${root}/static/wallpapers");
      };
    };

    # Previously set via Hyprland's `env = [...]` directive. The Lua API for
    # env vars isn't covered in the wiki, so they live here. Works when
    # launching from a TTY shell; may need adjustment for display-manager.
    home.sessionVariables = {
      XCURSOR_THEME = "Catppuccin Mocha Dark";
      XCURSOR_SIZE = "24";
      HYPRCURSOR_SIZE = "24";
      AQ_NO_MODIFIERS = "1";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      # Kept enabled for `hyprland-session.target` (binds services to the
      # graphical session). The HM module also injects a dbus-activation
      # exec-once into hyprland.conf, but Hyprland 0.55+ reads hyprland.lua
      # — we keep the equivalent dbus call in static/hypr/hyprland.lua
      # under hl.on("hyprland.start") as a belt-and-suspenders measure.
      systemd.enable = true;
      # Empty settings + a whitespace extraConfig suppresses the HM module's
      # "almost certainly a mistake" warning while still writing a near-empty
      # hyprland.conf. The real config lives in static/hypr/hyprland.lua,
      # symlinked to ~/.config/hypr above.
      settings = {};
      extraConfig = " ";
    };
  };
}
