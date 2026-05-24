local vars = require("parts/variables")

hl.bind(vars.mainMod .. " + SPACE", hl.dsp.exec_cmd(vars.menu))
hl.bind(vars.mainMod .. " + B", hl.dsp.exec_cmd(vars.webBrowser))
hl.bind(vars.mainMod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(vars.mainMod .. " + T", hl.dsp.exec_cmd(vars.terminal))
-- hl.bind(vars.mainMod .. " + E", hl.dsp.exec_cmd(fileManager))  -- fileManager unset
-- hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd(notes))        -- notes unset
hl.bind(vars.mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(vars.mainMod .. " + d", hl.dsp.exec_cmd("discord"))
hl.bind(vars.mainMod .. " + s", hl.dsp.exec_cmd("steam"))

-- Screenshot
hl.bind(vars.mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

-- NB: vars.mainMod + T below was also bound to exec terminal above. The
-- togglefloating bind overrides the terminal one (same as original).
hl.bind(vars.mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(vars.mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(vars.mainMod .. " + T", hl.dsp.window.float())
hl.bind(vars.mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Clipboard
hl.bind(vars.mainMod .. " + C", hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" }), { description = "Copy" })
hl.bind(vars.mainMod .. " + V", hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }), { description = "Paste" })
hl.bind(vars.mainMod .. " + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X" }), { description = "Cut" })

-- Close windows
hl.bind(vars.mainMod .. " + W", hl.dsp.window.close(), { description = "Close active window" })

-- Control tiling (re-declares J/P/T/F with descriptions, matching original)
hl.bind(vars.mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "Toggle split" })
hl.bind(vars.mainMod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind(vars.mainMod .. " + T", hl.dsp.window.float(), { description = "Toggle floating" })
hl.bind(
	vars.mainMod .. " + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen" }),
	{ description = "Force full screen" }
)
hl.bind(
	vars.mainMod .. " + CTRL + F",
	hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }),
	{ description = "Tiled full screen" }
)
hl.bind(vars.mainMod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })

-- Move focus
hl.bind(vars.mainMod .. " + LEFT", hl.dsp.focus({ direction = "l" }), { description = "Move focus left" })
hl.bind(vars.mainMod .. " + RIGHT", hl.dsp.focus({ direction = "r" }), { description = "Move focus right" })
hl.bind(vars.mainMod .. " + UP", hl.dsp.focus({ direction = "u" }), { description = "Move focus up" })
hl.bind(vars.mainMod .. " + DOWN", hl.dsp.focus({ direction = "d" }), { description = "Move focus down" })

-- Switch workspaces with vars.mainMod + [0-9]
for i = 1, 10 do
	hl.bind(
		vars.mainMod .. " + code:" .. (9 + i),
		hl.dsp.focus({ workspace = i }),
		{ description = "Switch to workspace " .. i }
	)
end

-- Move active window to a workspace with vars.mainMod + SHIFT + [0-9]
for i = 1, 10 do
	hl.bind(
		vars.mainMod .. " + SHIFT + code:" .. (9 + i),
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. i }
	)
end

-- TAB between workspaces
hl.bind(vars.mainMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(vars.mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous workspace" })
hl.bind(vars.mainMod .. " + CTRL + TAB", hl.dsp.focus({ workspace = "previous" }), { description = "Former workspace" })

-- Swap active window
hl.bind(
	vars.mainMod .. " + SHIFT + LEFT",
	hl.dsp.window.swap({ direction = "l" }),
	{ description = "Swap window to the left" }
)
hl.bind(
	vars.mainMod .. " + SHIFT + RIGHT",
	hl.dsp.window.swap({ direction = "r" }),
	{ description = "Swap window to the right" }
)
hl.bind(vars.mainMod .. " + SHIFT + UP", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind(
	vars.mainMod .. " + SHIFT + DOWN",
	hl.dsp.window.swap({ direction = "d" }),
	{ description = "Swap window down" }
)

-- Cycle through applications on active workspace.
-- Original had two binds per key (cyclenext + bringactivetotop); merged into one
-- function so both fire, since Lua binds can only have one handler per key combo.
hl.bind("ALT + TAB", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { description = "Cycle to next window" })
hl.bind("ALT + SHIFT + TAB", function()
	hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { description = "Cycle to prev window" })

-- Resize active window
hl.bind(
	vars.mainMod .. " + code:20",
	hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
	{ description = "Expand window left" }
) -- - key
hl.bind(
	vars.mainMod .. " + code:21",
	hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
	{ description = "Shrink window left" }
) -- = key
hl.bind(
	vars.mainMod .. " + SHIFT + code:20",
	hl.dsp.window.resize({ x = 0, y = -100, relative = true }),
	{ description = "Shrink window up" }
)
hl.bind(
	vars.mainMod .. " + SHIFT + code:21",
	hl.dsp.window.resize({ x = 0, y = 100, relative = true }),
	{ description = "Expand window down" }
)

-- Scroll through existing workspaces
hl.bind(
	vars.mainMod .. " + mouse_down",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "Scroll active workspace forward" }
)
hl.bind(
	vars.mainMod .. " + mouse_up",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "Scroll active workspace backward" }
)

-- Toggle groups
hl.bind(vars.mainMod .. " + G", hl.dsp.group.toggle(), { description = "Toggle window grouping" })
hl.bind(
	vars.mainMod .. " + ALT + G",
	hl.dsp.window.move({ out_of_group = true }),
	{ description = "Move active window out of group" }
)

-- Join groups
hl.bind(
	vars.mainMod .. " + ALT + LEFT",
	hl.dsp.window.move({ into_group = "l" }),
	{ description = "Move window to group on left" }
)
hl.bind(
	vars.mainMod .. " + ALT + RIGHT",
	hl.dsp.window.move({ into_group = "r" }),
	{ description = "Move window to group on right" }
)
hl.bind(
	vars.mainMod .. " + ALT + UP",
	hl.dsp.window.move({ into_group = "u" }),
	{ description = "Move window to group on top" }
)
hl.bind(
	vars.mainMod .. " + ALT + DOWN",
	hl.dsp.window.move({ into_group = "d" }),
	{ description = "Move window to group on bottom" }
)

-- Navigate a single set of grouped windows
hl.bind(vars.mainMod .. " + ALT + TAB", hl.dsp.group.next(), { description = "Next window in group" })
hl.bind(vars.mainMod .. " + ALT + SHIFT + TAB", hl.dsp.group.prev(), { description = "Previous window in group" })

-- Scroll through a set of grouped windows
hl.bind(vars.mainMod .. " + ALT + mouse_down", hl.dsp.group.next(), { description = "Next window in group" })
hl.bind(vars.mainMod .. " + ALT + mouse_up", hl.dsp.group.prev(), { description = "Previous window in group" })

-- Activate window in a group by number
for i = 1, 5 do
	hl.bind(
		vars.mainMod .. " + ALT + " .. i,
		hl.dsp.group.active({ index = i }),
		{ description = "Switch to group window " .. i }
	)
end

-- Move/resize windows with vars.mainMod + LMB/RMB and dragging
hl.bind(vars.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind(vars.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- Laptop multimedia keys for volume and LCD brightness (repeatable + locked)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), { repeating = true, locked = true })

-- Player keys (requires playerctl)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
