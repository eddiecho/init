local wallpaper_id = require("parts/wallpaper")

-- The kernel truncates the process name "linux-wallpaperengine" to 15
-- characters. pkill -x and pgrep -x must use the truncated name.
local function start_wallpaper()
	local screens = {}
	for _, monitor in ipairs(hl.get_monitors()) do
		table.insert(screens, "--screen-root " .. monitor.name)
	end
	hl.exec_cmd(
		"pkill -x linux-wallpaper; "
			.. "while pgrep -x linux-wallpaper >/dev/null; do sleep 0.1; done; "
			.. "exec linux-wallpaperengine --silent "
			.. table.concat(screens, " ")
			.. " "
			.. wallpaper_id
	)
end

-- Autostart commands (the dbus-update-activation-environment call is
-- emitted automatically by HM's systemd.enable = true).
hl.on("hyprland.start", function()
	start_wallpaper()
	hl.exec_cmd("swaync")
	hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 24")
	hl.exec_cmd("vicinae server")
end)

hl.on("monitor.added", start_wallpaper)
hl.on("monitor.removed", start_wallpaper)

require("parts/keybinds")
require("parts/settings")
