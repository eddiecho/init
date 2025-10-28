# System config for WSL based systems
{vals, ...}: rec {
  settings = {
    username = vals.username;
    fullName = vals.fullName;
    email = vals.email;
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
    wsl.enable = true;
    kernel.enable = true;
  };

  users.mutableUsers = true;

  networking.hostName = "window";

  system.stateVersion = vals.stateVersion;
}
