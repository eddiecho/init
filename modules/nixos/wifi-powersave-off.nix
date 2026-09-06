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

    # TLP hooks sleep.target too, in tlp-sleep.service. Systemd does not
    # order tlp-sleep.service and wifi-powersave-off-resume relative to
    # each other at resume. tlp-sleep.service runs `tlp resume` on stop.
    # `tlp resume` turns WiFi power save back on by default. This can
    # undo wifi-powersave-off-resume, at random, after every resume.
    # Force TLP off. This module is then the only service that sets
    # WiFi power save.
    services.tlp.enable = lib.mkForce false;

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
          ExecStart = "${pkgs.coreutils}/bin/true";
          ExecStop = "${pkgs.iw}/bin/iw dev ${cfg.interface} set power_save off";
        };
      };
    };
  };
}
