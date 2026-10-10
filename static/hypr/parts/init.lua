local vars = require("parts/variables")
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

-- Discord opens its main window from a different process than the updater window.
-- Thus an exec_cmd rule does not apply to the main window.
-- This rule matches the class instead, and stops after the main window opens.
-- Call this function only from hyprland.start. A config reload must not enable the rule again.
local function start_discord()
	local rule = hl.window_rule({
		name = "discord-autostart-workspace",
		match = { class = "^discord$" },
		workspace = "3 silent",
	})
	local subscription
	subscription = hl.on("window.open", function(window)
		if window.class == "discord" and window.title ~= "Discord Updater" then
			rule:set_enabled(false)
			subscription:remove()
		end
	end)
	hl.exec_cmd("discord")
end

-- Autostart commands (the dbus-update-activation-environment call is
-- emitted automatically by HM's systemd.enable = true).
hl.on("hyprland.start", function()
	start_wallpaper()
	hl.exec_cmd("[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources")
	hl.exec_cmd("swaync")
	hl.exec_cmd("hyprctl setcursor catppuccin-mocha-dark-cursors 24")
	hl.exec_cmd("vicinae server")
	hl.exec_cmd(vars.terminal, { workspace = "1 silent" })
	hl.exec_cmd(vars.webBrowser, { workspace = "2 silent" })
	start_discord()
end)

hl.on("monitor.added", start_wallpaper)
hl.on("monitor.removed", start_wallpaper)

require("parts/keybinds")
require("parts/settings")
