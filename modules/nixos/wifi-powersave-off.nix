{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.wifiPowersaveOff;
in {
  options.nixos.wifiPowersaveOff = {
    enable = lib.mkEnableOption "Disable WiFi power save on boot and resume";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "wlan0";
      example = "wlp1s0";
      description = "Network interface to disable power save on.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.iw];

    # retarded mongrel dogshit
    # IN WHAT UNIVERSE IS IT A GOOD IDEA TO TURN OFF WIFI
    # ON A FUCKING LAPTOP TO SAVE POWER???????????????
    systemd.services = {
      wifi-powersave-off = {
        description = "Disable WiFi power save at boot";
        wantedBy = ["multi-user.target"];
        after = ["sys-subsystem-net-devices-${cfg.interface}.device"];
        bindsTo = ["sys-subsystem-net-devices-${cfg.interface}.device"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.iw}/bin/iw dev ${cfg.interface} set power_save off";
        };
      };

      # https://www.freedesktop.org/software/systemd/man/latest/systemd.special.html#sleep.target
      # ExecStop runs after the system wakes, not before it sleeps.
      wifi-powersave-off-resume = {
        description = "Disable WiFi power save after resume";
        unitConfig = {
          DefaultDependencies = false;
          StopWhenUnneeded = true;
        };
        before = ["sleep.target"];
        wantedBy = ["sleep.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "true";
          ExecStop = "${pkgs.iw}/bin/iw dev ${cfg.interface} set power_save off";
        };
      };
    };
  };
}
