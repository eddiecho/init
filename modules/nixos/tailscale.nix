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

    services.caddy = {
      enable = true;
      virtualHosts."${config.networking.hostName}.azules-stargazer.ts.net".extraConfig = "";
    };

    # default NAS port is 8080
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "both";
    };
  };
}
