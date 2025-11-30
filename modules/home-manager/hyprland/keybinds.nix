{
  config,
  lib,
  ...
}: let
  cfg = config.modules.hyprland;
in {
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      gestures.workspace_swipe_invert = false;
      gestures.workspace_swipe_distance = 700;
      gesture = [
        "3, horizontal, workspace"
      ];

      # basically copying omarchy's bindings
      bind = [
        "$mainMod, SPACE , exec, $terminal"
        "$mainMod, B, exec, $webBrowser"
        "$mainMod SHIFT, M, exit"
        "$mainMod, A, exec, $menu"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, N, exec, $notes"
        "$mainMod_SHIFT, L, exec, hyprlock"
        "$mainMod, d, exec, discord"
        "$mainMod, s, exec, steam"

        # Screenshot
        "$mainMod, PRINT, exec, hyprshot -m window"
        ", PRINT, exec, hyprshot -m output"
        "$shiftMod, PRINT, exec, hyprshot -m region"

        "$mainMod, J, togglesplit" # dwindle
        "$mainMod, P, pseudo" # dwindle
        "$mainMod, T, togglefloating"
        "$mainMod, F, fullscreen"
      ];

      # the d stands for description
      bindd = [
        # Clipboard
        "$mainMod, C, Copy, sendshortcut, CTRL, Insert"
        "$mainMod, V, Paste, sendshortcut, SHIFT, Insert"
        "$mainMod, X, Cut, sendshortcut, CTRL, X"

        # Close windows
        "$mainMod, W, Close active window, killactive"
        # "CTRL ALT, DELETE, Close all Windows, exec, omarchy-hyprland-window-close-all"

        # Control tiling
        "$mainMod, J, Toggle split, togglesplit," # dwindle
        "$mainMod, P, Pseudo window, pseudo," # dwindle
        "$mainMod, T, Toggle floating, togglefloating,"
        "$mainMod, F, Force full screen, fullscreen, 0"
        "$mainMod CTRL, F, Tiled full screen, fullscreenstate, 0 2"
        "$mainMod ALT, F, Full width, fullscreen, 1"

        # Move focus with $mainMod + arrow keys
        "$mainMod, LEFT, Move focus left, movefocus, l"
        "$mainMod, RIGHT, Move focus right, movefocus, r"
        "$mainMod, UP, Move focus up, movefocus, u"
        "$mainMod, DOWN, Move focus down, movefocus, d"

        # Switch workspaces with $mainMod + [0-9]
        "$mainMod, code:10, Switch to workspace 1, workspace, 1"
        "$mainMod, code:11, Switch to workspace 2, workspace, 2"
        "$mainMod, code:12, Switch to workspace 3, workspace, 3"
        "$mainMod, code:13, Switch to workspace 4, workspace, 4"
        "$mainMod, code:14, Switch to workspace 5, workspace, 5"
        "$mainMod, code:15, Switch to workspace 6, workspace, 6"
        "$mainMod, code:16, Switch to workspace 7, workspace, 7"
        "$mainMod, code:17, Switch to workspace 8, workspace, 8"
        "$mainMod, code:18, Switch to workspace 9, workspace, 9"
        "$mainMod, code:19, Switch to workspace 10, workspace, 10"

        # Move active window to a workspace with $mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, code:10, Move window to workspace 1, movetoworkspace, 1"
        "$mainMod SHIFT, code:11, Move window to workspace 2, movetoworkspace, 2"
        "$mainMod SHIFT, code:12, Move window to workspace 3, movetoworkspace, 3"
        "$mainMod SHIFT, code:13, Move window to workspace 4, movetoworkspace, 4"
        "$mainMod SHIFT, code:14, Move window to workspace 5, movetoworkspace, 5"
        "$mainMod SHIFT, code:15, Move window to workspace 6, movetoworkspace, 6"
        "$mainMod SHIFT, code:16, Move window to workspace 7, movetoworkspace, 7"
        "$mainMod SHIFT, code:17, Move window to workspace 8, movetoworkspace, 8"
        "$mainMod SHIFT, code:18, Move window to workspace 9, movetoworkspace, 9"
        "$mainMod SHIFT, code:19, Move window to workspace 10, movetoworkspace, 10"

        # TAB between workspaces
        "$mainMod, TAB, Next workspace, workspace, e+1"
        "$mainMod SHIFT, TAB, Previous workspace, workspace, e-1"
        "$mainMod CTRL, TAB, Former workspace, workspace, previous"

        # Swap active window with the one next to it with $mainMod + SHIFT + arrow keys
        "$mainMod SHIFT, LEFT, Swap window to the left, swapwindow, l"
        "$mainMod SHIFT, RIGHT, Swap window to the right, swapwindow, r"
        "$mainMod SHIFT, UP, Swap window up, swapwindow, u"
        "$mainMod SHIFT, DOWN, Swap window down, swapwindow, d"

        # Cycle through applications on active workspace
        "ALT, TAB, Cycle to next window, cyclenext"
        "ALT SHIFT, TAB, Cycle to prev window, cyclenext, prev"
        "ALT, TAB, Reveal active window on top, bringactivetotop"
        "ALT SHIFT, TAB, Reveal active window on top, bringactivetotop"

        # Resize active window
        "$mainMod, code:20, Expand window left, resizeactive, -100 0" # - key
        "$mainMod, code:21, Shrink window left, resizeactive, 100 0" # = key
        "$mainMod SHIFT, code:20, Shrink window up, resizeactive, 0 -100"
        "$mainMod SHIFT, code:21, Expand window down, resizeactive, 0 100"

        # Scroll through existing workspaces with $mainMod + scroll
        "$mainMod, mouse_down, Scroll active workspace forward, workspace, e+1"
        "$mainMod, mouse_up, Scroll active workspace backward, workspace, e-1"

        # Toggle groups
        "$mainMod, G, Toggle window grouping, togglegroup"
        "$mainMod ALT, G, Move active window out of group, moveoutofgroup"

        # Join groups
        "$mainMod ALT, LEFT, Move window to group on left, moveintogroup, l"
        "$mainMod ALT, RIGHT, Move window to group on right, moveintogroup, r"
        "$mainMod ALT, UP, Move window to group on top, moveintogroup, u"
        "$mainMod ALT, DOWN, Move window to group on bottom, moveintogroup, d"

        # Navigate a single set of grouped windows
        "$mainMod ALT, TAB, Next window in group, changegroupactive, f"
        "$mainMod ALT SHIFT, TAB, Previous window in group, changegroupactive, b"

        # Scroll through a set of grouped windows with $mainMod + ALT + scroll
        "$mainMod ALT, mouse_down, Next window in group, changegroupactive, f"
        "$mainMod ALT, mouse_up, Previous window in group, changegroupactive, b"

        # Activate window in a group by number
        "$mainMod ALT, 1, Switch to group window 1, changegroupactive, 1"
        "$mainMod ALT, 2, Switch to group window 2, changegroupactive, 2"
        "$mainMod ALT, 3, Switch to group window 3, changegroupactive, 3"
        "$mainMod ALT, 4, Switch to group window 4, changegroupactive, 4"
        "$mainMod ALT, 5, Switch to group window 5, changegroupactive, 5"
      ];

      bindmd = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, Move window, movewindow"
        "$mainMod, mouse:273, Resize window, resizewindow"
      ];

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];

      # Requires playerctl
      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };
}
