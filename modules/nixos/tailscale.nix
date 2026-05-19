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

    tailnetDomain = lib.mkOption {
      type = lib.types.str;
      example = "azules-stargazer.ts.net";
      description = ''
        The MagicDNS domain of your tailnet (e.g. `azules-stargazer.ts.net`),
        without leading dot or hostname. Used to build the Caddy vhost as
        `<hostname>.<tailnetDomain>`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tailscale
    ];

    services.caddy = {
      enable = true;
      virtualHosts."${config.networking.hostName}.${cfg.tailnetDomain}".extraConfig = "";
    };

    # default NAS port is 8080
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "both";
    };
  };
}
