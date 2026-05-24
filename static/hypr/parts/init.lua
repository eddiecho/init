-- Autostart commands (the dbus-update-activation-environment call is
-- emitted automatically by HM's systemd.enable = true).
hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("awww img ~/Pictures/wallpaper.gif")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hyprctl setcursor Catppuccin Mocha Dark 24")
	hl.exec_cmd("vicinae server")
end)

require("parts/keybinds")
require("parts/settings")
