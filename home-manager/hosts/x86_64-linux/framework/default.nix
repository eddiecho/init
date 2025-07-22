# System config for my nixos laptop
let
  vals = {
    username = "eddie";
    fullName = "Eddie Cho";
    stateVersion = "24.11";
  };
in rec {
  home-manager.users.${vals.username} = {
    settings = {
      username = vals.username;
      fullName = vals.fullName;
    };

    hm = {
      common.enable = true;
    };

    home.stateVersion = vals.stateVersion;
  };

  nixos = {
    common.enable = true;
    kernel.enable = true;
  };

  system.stateVersion = vals.stateVersion;
}
