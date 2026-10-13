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
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "azules-stargazer.ts.net";
    };

    caddy.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Serve <hostName>.<tailnetDomain> through Caddy with a Tailscale certificate.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.caddy.enable -> cfg.tailnetDomain != null;
        message = "nixos.tailscale.caddy.enable requires nixos.tailscale.tailnetDomain.";
      }
    ];

    environment.systemPackages = with pkgs; [
      tailscale
    ];

    services.caddy = lib.mkIf cfg.caddy.enable {
      enable = true;
      virtualHosts."${config.networking.hostName}.${cfg.tailnetDomain}".extraConfig = "";
    };

    # default NAS port is 8080
    services.tailscale = {
      enable = true;
      permitCertUid = lib.mkIf cfg.caddy.enable "caddy";
      useRoutingFeatures = "both";
    };
  };
}
