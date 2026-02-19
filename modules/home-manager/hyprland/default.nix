{lib, ...}: {
  options.modules.hyprland.enable = lib.mkEnableOption "Enable Hyprland";

  imports = [
    ./pkgs.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./keybinds.nix
    ./waybar.nix
    ./vicinae.nix
  ];
}
