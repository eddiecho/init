# System config for WSL based systems
let
  vals = {
    username = "eddie";
    fullName = "Eddie Cho";
    stateVersion = "24.11";
  };
in {
  home-manager.users.${vals.username} = {
    settings = {
      username = vals.username;
      fullName = vals.fullName;
    };

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

  system.stateVersion = vals.stateVersion;
}
