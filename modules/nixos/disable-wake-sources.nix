{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.disableWakeSources;
in {
  options.nixos.disableWakeSources = {
    enable = lib.mkEnableOption "Disable listed ACPI wake sources at boot";

    devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["XHCI" "TXHC"];
      description = "Device names, as they appear in the first column of /proc/acpi/wakeup, to disable as wake sources.";
    };
  };

  # /proc/acpi/wakeup toggles a device's state on write. It does not
  # accept an absolute on/off value. Check the current state first.
  # Only write a name that currently reads "*enabled".
  config = lib.mkIf cfg.enable {
    systemd.services.disable-wake-sources = {
      description = "Disable selected ACPI wake sources";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "disable-wake-sources" ''
          set -euo pipefail
          targets="${lib.concatStringsSep " " cfg.devices}"
          while read -r name state status _; do
            for target in $targets; do
              if [ "$name" = "$target" ] && [ "$status" = "*enabled" ]; then
                echo "$name" > /proc/acpi/wakeup
              fi
            done
          done < /proc/acpi/wakeup
        '';
      };
    };
  };
}
