# overlays.default expects nixpkgs to provide Hyprland's own libraries
# (hyprland-guiutils, aquamarine, ...). nixpkgs lags behind Hyprland master.
# hyprland-packages also overlays those libraries.
inputs: final: prev:
inputs.nixpkgs.lib.composeManyExtensions [
  inputs.hyprland.overlays.hyprland-packages
  inputs.hyprland.overlays.hyprland-extras
]
final
prev
