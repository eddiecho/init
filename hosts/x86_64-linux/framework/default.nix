# System config for my nixos laptop
{
  nixos-hardware,
  pkgs,
  vals,
  ...
}: rec {
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.framework-13-7040-amd
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
      hyprland.enable = true;
      display.enable = true;

      apps = {
        ghostty.enable = true;
        discord.enable = true;
      };
    };

    home.stateVersion = vals.stateVersion;
  };

  nixos = {
    common.enable = true;
    kernel.enable = true;
    display.enable = true;
    tailscale.enable = true;
    moonlight.enable = true;
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  users.mutableUsers = true;

  # iwctl station wlan0 connect "wifi-name"
  networking.hostName = "framework";
  networking.wireless.iwd.enable = true;
  networking.nameservers = [
    "192.168.0.26"
    "192.168.0.1"
  ];
  # networking.nameservers = [ "8.8.8.8" ];

  nixpkgs.hostPlatform = "x86_64-linux";

  security.polkit.enable = true;

  hardware.cpu.amd.updateMicrocode = true;
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

