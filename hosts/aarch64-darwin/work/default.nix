# System config for my work macbooks
let
  vals = {
    username = "Eddie.Cho";
    fullName = "Eddie Cho";
    stateVersion = "24.11";
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
    };

    home.stateVersion = "24.11";
  };

  system.stateVersion = 6;
}
