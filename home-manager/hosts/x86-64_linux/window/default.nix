# System config for WSL based systems

rec {
  eddie.settings = {
    username = "eddie";
    fullName = "Eddie Cho";
  };

  eddie.profiles = {
    base.enable = true;
    wsl.enable = true;
  };

  home-manager.users."eddie" = {
    eddie.settings = {
      username = eddie.settings.username;
      fullName = eddie.settings.fullName;
    };

    eddie.profiles = {
      common.enable = true;
    };

    home.stateVersion = "24.11";
  };

  system.stateVersion = "24.11";
}
