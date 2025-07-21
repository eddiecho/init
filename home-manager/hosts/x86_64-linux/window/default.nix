# System config for WSL based systems

let
  vals = {
    username = "eddie";
    fullName = "Eddie Cho";
    stateVersion = "24.11";
  };

in rec {
  home-manager.users."eddie" = {
    settings = {
      username = vals.username;
      fullName = vals.fullName;
    };

    home.stateVersion = vals.stateVersion;
  };

  mixins = {
    common.enable = true;
    wsl.enable = true;
  };

  system.stateVersion = vals.stateVersion;
}
