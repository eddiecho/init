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
      # The SSH server must stay reachable when no Windows terminal is open.
      wslconfig.wsl2.vmIdleTimeout = -1;
    };
    tailscale = {
      enable = true;
      caddy.enable = false;
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

  system.stateVersion = vals.stateVersion;
}
