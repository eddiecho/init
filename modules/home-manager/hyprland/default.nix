{lib, ...}: {
  options.modules.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland";
    scale = lib.mkOption {
      type = lib.types.number;
      default = 1;
      description = "Scale for all monitors. Hyprland rejects a scale that does not divide the resolution evenly.";
    };
  };

  imports = [
    ./pkgs.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./waybar.nix
    ./vicinae.nix
  ];
}
