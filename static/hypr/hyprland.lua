-- Hyprland config entrypoint. See https://wiki.hypr.land/Configuring/Start/
-- The real content lives in parts/, loaded in order (later files can use
-- globals declared earlier).

local parts = os.getenv("HOME") .. "/.config/hypr/parts"
dofile(parts .. "/variables.lua")
dofile(parts .. "/settings.lua")
dofile(parts .. "/keybinds.lua")
