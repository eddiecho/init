# System config for my nixos laptop
{
  nixos-hardware,
  pkgs,
  vals,
  lib,
  ...
}: rec {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    nixos-hardware.nixosModules.framework-intel-core-ultra-series3
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
  ];

  settings = {
    username = vals.username;
    fullName = vals.fullName;
    email = vals.email;
  };

  home-manager.users.${vals.username} = {
    settings = settings;
    modules = {
      common.enable = true;
      hyprland = {
        enable = true;
        scale = 1.6;
      };
      display.enable = true;

      apps = {
        ghostty.enable = true;
        yazi.enable = true;
      };
    };

    catppuccin = {
      flavor = "mocha";
      enable = true;
      autoEnable = true;
    };

    home.stateVersion = vals.stateVersion;
  };

  nixos = {
    discord.enable = true;
    common.enable = true;
    kernel.enable = true;
    display.enable = true;
    tailscale = {
      enable = true;
      tailnetDomain = "azules-stargazer.ts.net";
    };
    moonlight.enable = true;
    steam.enable = true;
    disableWakeSources = {
      enable = true;
      devices = ["XHCI" "TXHC" "TDM0" "TDM1" "TRP0" "TRP1" "TRP2" "TRP3"];
    };
  };

  catppuccin = {
    flavor = "mocha";
    enable = true;
    autoEnable = true;
    cache.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # nixos-hardware's framework/13-inch/common/intel.nix adds
    # nvme.noacpi=1. That flag makes the kernel ignore the firmware's
    # StorageD3Enable hint, so the NVMe drive stays in D0 during s2idle.
    # The kernel applies the last value of a repeated module parameter.
    # mkAfter puts this value after the nixos-hardware value.
    kernelParams = lib.mkAfter ["nvme.noacpi=0"];
  };

  users.mutableUsers = true;

  # iwctl station wlan0 connect "wifi-name"
  networking.hostName = "frameworkpro";
  networking.wireless.iwd = {
    enable = true;
    settings.DriverQuirks.PowerSaveDisable = "*";
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  security.polkit.enable = true;

  services.tlp.enable = lib.mkForce false;

  hardware.graphics = {
    enable = true;
  };

  fonts = {
    packages = with pkgs; [
      sfmono
    ];
  };

  system.stateVersion = vals.stateVersion;

  # i don't know, some home-manager thing
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];
}
