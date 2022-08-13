local wezterm = require 'wezterm';
local string = require'string';

local colorscheme_onenord = {
  background = "#2E3440",
  black = "#4C566A",
  blue = "#81A1C1",
  brightBlack = "#3B4252",
  brightBlue = "#81A1C1",
  brightCyan = "#88C0D0",
  brightGreen = "#A3BE8C",
  brightPurple =  "#B988B0",
  brightRed = "#BF616A",
  brightWhite = "#E5E9F0",
  brightYellow = "#EBCB8B",
  cursorColor = "#81A1C1",
  cyan = "#8FBCBB",
  foreground = "#C8D0E0",
  green = "#A3BE8C",
  purple = "#B988B0",
  red = "#BF616A",
  selectionBackground = "#434C5E",
  white = "#ECEFF4",
  yellow = "#EBCB8B",
}

wezterm.on("ctrl-c-custom-event", function(window, pane)
  local sel = window:get_selection_text_for_pane(pane)
  if string.len(sel) >= 1 then
    window:perform_action(wezterm.action{CopyTo="ClipboardAndPrimarySelection"}, pane)
  else
    window:perform_action(wezterm.action{SendKey={key="c", mods="CTRL"}}, pane)
  end
end)

local wsl_domains = wezterm.default_wsl_domains()
for idx, dom in ipairs(wsl_domains) do
  dom.default_cwd = "/home/eddie"
end

return {
  default_domain = "WSL:Ubuntu-20.04",
  font = wezterm.font_with_fallback({
    {family="SFMono Nerd Font", weight="Bold"},
  }),
  keys = {
    {key="t", mods="CTRL", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
    {key="w", mods="CTRL", action=wezterm.action{CloseCurrentPane={confirm=false}}},
    {key="d", mods="CTRL", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    {key = "LeftArrow", mods="CTRL",
      action=wezterm.action{ActivatePaneDirection="Left"}},
    {key = "RightArrow", mods="CTRL",
      action=wezterm.action{ActivatePaneDirection="Right"}},
    {key = "UpArrow", mods="CTRL",
      action=wezterm.action{ActivatePaneDirection="Up"}},
    {key = "DownArrow", mods="CTRL",
      action=wezterm.action{ActivatePaneDirection="Down"}},
    {key="v", mods="CTRL", action=wezterm.action{PasteFrom="Clipboard"}},
    {key="c", mods="CTRL", action=wezterm.action{EmitEvent="ctrl-c-custom-event"}},
  },

  skip_close_confirmation_for_processes_named = {
        "bash",
        "sh",
        "zsh",
        "fish",
        "tmux",
        "nu",
        "cmd.exe",
        "pwsh.exe",
        "powershell.exe",
        "wsl.exe"
  },
  window_close_confirmation = "NeverPrompt",

  color_schemes = {
     ["Onenord"] = colorscheme_onenord
  },
  color_scheme = "Onenord",
  check_for_update = false,
  wsl_domains = wsl_domains,
}

