# System config for my work macbooks
{...}: let
  vals = {
    username = "Eddie.Cho";
    fullName = "Eddie Cho";
    stateVersion = "25.05";
  };
in {
  darwin = {
    common.enable = true;
  };

  home-manager.users.${vals.username} = {
    settings = {
      username = vals.username;
      fullName = vals.fullName;
    };

    modules = {
      common.enable = true;
      display.enable = false;
      hyprland.enable = false;
    };

    home.stateVersion = vals.stateVersion;
  };

  system.stateVersion = 6;
}
