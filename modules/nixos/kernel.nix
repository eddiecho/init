{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.kernel;
in {
  options.nixos.kernel.enable = lib.mkEnableOption "Enable kernel tweaks";

  config = lib.mkIf cfg.enable {
    # I got the need for speed, baby
    boot.kernelParams = [
      "mitigations=off"
      # "default" leaves each PCIe link's ASPM state at whatever the
      # firmware set. "powersupersave" forces the deepest link power
      # state everywhere. This matters most for s2idle suspend: this
      # hardware has no S3 state (/sys/power/mem_sleep offers only
      # s2idle), so idle PCIe links are one of the few levers left to
      # cut suspend power draw.
      "pcie_aspm.policy=powersupersave"
    ];
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
