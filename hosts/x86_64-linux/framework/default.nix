# System config for my nixos laptop
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
      hyprland.enable = true;
    };

    home.stateVersion = vals.stateVersion;
  };

  nixos = {
    common.enable = true;
    kernel.enable = true;
    display.enable = true;
  };

  system.stateVersion = vals.stateVersion;
}
