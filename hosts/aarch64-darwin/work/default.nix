# System config for my work macbooks
{vals, ...}: let
in rec {
  settings = {
    username = vals.darwinUsername;
    fullName = vals.fullName;
  };

  darwin = {
    settings = settings;
    common.enable = true;
  };

  home-manager.users.${vals.username} = {
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
