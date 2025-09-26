{lib, ...}: {
  options.modules.hyprland.enable = lib.mkEnableOption "Enable Hyprland";

  imports = [
    ./pkgs.nix
    ./hyprland.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./tofi.nix
    ./keybinds.nix
  ];
}
