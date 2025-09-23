# System config for my nixos laptop
{
  inputs,
  ...
}: let
  vals = {
    username = "eddie";
    fullName = "Eddie Cho";
    stateVersion = "25.05";
  };
in {
  home-manager.users.${vals.username} = {
    settings = {
      username = vals.username;
      fullName = vals.fullName;
    };

    modules = {
      common.enable = true;
      hyprland.enable = true;
    };

    home.stateVersion = vals.stateVersion;
  };

  nixos = {
    common.enable = true;
    kernel.enable = true;
    display.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  users.mutableUsers = true;
  system.stateVersion = vals.stateVersion;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/10ed4b76-5ac2-4c1e-baef-eca230f1c0e7";
      fsType = "ext4";
    };
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E204-4398";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices = [ ];

  networking.useDHCP = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;

  hardware.opengl = {
    enable = true;
  };
}
