-- Monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Settings
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 0,
    },
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_rules = "",
        kb_options = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
            clickfinger_behavior = false,
            disable_while_typing = false,
            tap_and_drag = false,
        },
    },
    cursor = {
        inactive_timeout = 3,
        no_hardware_cursors = 1,
    },
    decoration = {
        rounding = 8,
        active_opacity = 1,
        inactive_opacity = 1,
        dim_inactive = true,
        dim_strength = 0.1,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            new_optimizations = true,
            ignore_opacity = true,
        },
        shadow = {
            enabled = true,
            range = 5,
            render_power = 3,
            offset = { 0, 0 },
            color = "rgba(17,17,27,1.0)",
            color_inactive = "rgba(17,17,27,0.0)",
        },
    },
    group = {
        groupbar = {
            font_family = "SFMono",
            font_size = 14,
            gradients = true,
        },
    },
    binds = {
        movefocus_cycles_fullscreen = false,
        workspace_center_on = 1,
        focus_preferred_method = 0,
    },
    animations = {
        enabled = true,
    },
    dwindle = {
        preserve_split = true,
        force_split = 2,
        default_split_ratio = 1,
    },
    master = {
        new_status = "slave",
    },
    misc = {
        disable_hyprland_logo = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        force_default_wallpaper = -1,
    },
    gestures = {
        workspace_swipe_invert = true,
        workspace_swipe_distance = 700,
    },
})

-- Animation curves. "default" is our own ease curve so the animation
-- entries below don't depend on Hyprland having a built-in by that name.
hl.curve("default",   { type = "bezier", points = { { 0.25, 0.1  }, { 0.25, 1.0  } } })
hl.curve("slow",      { type = "bezier", points = { { 0,    0.85 }, { 0.3,  1    } } })
hl.curve("overshot",  { type = "bezier", points = { { 0.7,  0.6  }, { 0.1,  1.1  } } })
hl.curve("bounce",    { type = "bezier", points = { { 1,    1.6  }, { 0.1,  0.85 } } })
hl.curve("slingshot", { type = "bezier", points = { { 1,   -1    }, { 0.15, 1.25 } } })
hl.curve("myBezier",  { type = "bezier", points = { { 0.05, 0.9  }, { 0.1,  1.05 } } })

-- Animations. speed is in ds (1ds = 100ms). The curve param is named
-- `bezier` or `spring` in the actual API (wiki docs of `curve = ...` are
-- misleading).
hl.animation({ leaf = "windows",    enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6,  bezier = "default" })

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Window rules
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({ match = { class = "^(firefox)$" }, opacity = "1.0 1.0" })
hl.window_rule({ match = { class = "^([Ss]team)$" }, opacity = "0.70 0.70" })
hl.window_rule({ match = { class = "^(steamwebhelper)$" }, opacity = "0.70 0.70" })
hl.window_rule({ match = { class = "^([Ss]potify)$" }, opacity = "0.70 0.70" })
hl.window_rule({ match = { initial_title = "^(Spotify Free)$" }, opacity = "0.70 0.70" })
hl.window_rule({ match = { initial_title = "^(Spotify Premium)$" }, opacity = "0.70 0.70" })

hl.window_rule({ match = { class = "^(discord)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(WebCord)$" }, opacity = "0.80 0.80" })
hl.window_rule({ match = { class = "^(ArmCord)$" }, opacity = "0.80 0.80" })

hl.window_rule({ match = { class = "^(org.kde.dolphin)$", title = "^(Progress Dialog — Dolphin)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.dolphin)$", title = "^(Copying — Dolphin)$" }, float = true })
hl.window_rule({ match = { title = "^(About Mozilla Firefox)$" }, float = true })
hl.window_rule({ match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { class = "^(firefox)$", title = "^(Library)$" }, float = true })
hl.window_rule({ match = { class = "^(kitty)$", title = "^(top)$" }, float = true })
hl.window_rule({ match = { class = "^(kitty)$", title = "^(btop)$" }, float = true })
hl.window_rule({ match = { class = "^(kitty)$", title = "^(htop)$" }, float = true })
hl.window_rule({ match = { class = "^(vlc)$" }, float = true })
hl.window_rule({ match = { class = "^(kvantummanager)$" }, float = true })
hl.window_rule({ match = { class = "^(qt5ct)$" }, float = true })
hl.window_rule({ match = { class = "^(qt6ct)$" }, float = true })
hl.window_rule({ match = { class = "^(nwg-look)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.ark)$" }, float = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-applet)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, float = true })

hl.window_rule({ match = { class = "^(Signal)$" }, float = true })
hl.window_rule({ match = { class = "^(com.github.rafostar.Clapper)$" }, float = true })
hl.window_rule({ match = { class = "^(app.drey.Warp)$" }, float = true })
hl.window_rule({ match = { class = "^(net.davidotek.pupgui2)$" }, float = true })
hl.window_rule({ match = { class = "^(yad)$" }, float = true })
hl.window_rule({ match = { class = "^(eog)$" }, float = true })
hl.window_rule({ match = { class = "^(io.github.alainm23.planify)$" }, float = true })
hl.window_rule({ match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" }, float = true })
hl.window_rule({ match = { class = "^(com.github.unrud.VideoDownloader)$" }, float = true })
hl.window_rule({ match = { class = "^(io.gitlab.adhami3310.Impression)$" }, float = true })
hl.window_rule({ match = { class = "^(io.missioncenter.MissionCenter)$" }, float = true })

hl.window_rule({ match = { title = "^(Open)$" }, float = true })
hl.window_rule({ match = { title = "^(Choose Files)$" }, float = true })
hl.window_rule({ match = { title = "^(Save As)$" }, float = true })
hl.window_rule({ match = { title = "^(Confirm to replace files)$" }, float = true })
hl.window_rule({ match = { title = "^(File Operation Progress)$" }, float = true })
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, float = true })

hl.window_rule({ match = { title = "^(pop-up)$" }, float = true, pin = true, size = { 800, 600 } })

-- Layer rules
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "tofi" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync" }, blur = true })
