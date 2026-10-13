# System config for WSL based systems
{vals, ...}: rec {
  settings = {
    username = vals.username;
    fullName = vals.fullName;
    email = vals.email;
    anonEmail = vals.anonEmail;
    anonName = vals.anonName;
  };

  home-manager.users.${vals.username} = {
    settings = settings;

    modules = {
      common.enable = true;
    };

    home.stateVersion = vals.stateVersion;
  };

  nixos = {
    common.enable = true;
    kernel.enable = true;
    wsl = {
      enable = true;
      windowsUsername = vals.windowsUsername;
      wslconfig.wsl2 = {
        networkingMode = "mirrored";
        # The SSH server must stay reachable when no Windows terminal is open.
        vmIdleTimeout = -1;
      };
    };
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  users.users.${vals.username}.openssh.authorizedKeys.keys = vals.sshAuthorizedKeys or [];

  catppuccin = {
    enable = false;
    autoEnable = false;
  };

  users.mutableUsers = true;

  networking.hostName = "window";

  system.stateVersion = vals.stateVersion;
}
