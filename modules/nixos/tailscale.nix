{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.tailscale;
in {
  options.nixos.tailscale = {
    enable = lib.mkEnableOption "Enable tailscale";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tailscale
    ];

    services.tailscale.enable = true;
  };
}
