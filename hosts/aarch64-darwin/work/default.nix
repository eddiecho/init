# System config for my work macbooks
{vals, ...}: rec {
  settings = {
    username = vals.darwinUsername;
    fullName = vals.fullName;
    email = vals.workEmail;
  };

  darwin = {
    common.enable = true;
  };

  home-manager.users.${settings.username} = {
    settings = settings;
    modules = {
      common.enable = true;
      display.enable = false;
      hyprland.enable = false;
    };

    home.stateVersion = vals.stateVersion;
  };

  system.stateVersion = 6;
}
