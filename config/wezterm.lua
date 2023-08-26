local wezterm = require 'wezterm';
local string = require'string';

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

  color_scheme = "Catppuccin Mocha",

  font = wezterm.font_with_fallback({
    {family="SFMono Nerd Font", weight="Bold"},
    "nonicons"
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

  show_update_window = false,
  wsl_domains = wsl_domains,
}

