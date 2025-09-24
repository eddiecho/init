# System config for my nixos laptop
{
  inputs,
  pkgs,
  ...
}: let
  vals = {
    username = "eddie";
    fullName = "Eddie Cho";
    stateVersion = "25.05";
  };
in {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
  ];

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

  users.mutableUsers = true;

  networking.hostName = "framework";
  networking.wireless.iwd.enable = true;

  nixpkgs.hostPlatform = "x86_64-linux";

  security.polkit.enable = true;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.graphics = {
    enable = true;
  };

  system.stateVersion = vals.stateVersion;
}
