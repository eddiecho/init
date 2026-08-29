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
      };
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
  };

  users.mutableUsers = true;

  # iwctl station wlan0 connect "wifi-name"
  networking.hostName = "framework";
  networking.wireless.iwd.enable = true;

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

  # retarded mongrel dogshit
  # in what fucking universe DO WE TURN WIFI OFF
  # ON A FUCKING LAPTOP FOR """"POWER SAVING""""???????
  environment.systemPackages = [pkgs.iw];
  systemd.services = {
    wifi-powersave-off = {
      description = "Disable WiFi power save at boot";
      wantedBy = ["multi-user.target"];
      after = ["sys-subsystem-net-devices-wlan0.device"];
      bindsTo = ["sys-subsystem-net-devices-wlan0.device"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.iw}/bin/iw dev wlan0 set power_save off";
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
        ExecStop = "${pkgs.iw}/bin/iw dev wlan0 set power_save off";
      };
    };
  };
}
