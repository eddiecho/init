{
  config,
  lib,
  ...
}: let
  cfg = config.nixos.wsl;
in {
  options.nixos.wsl = {
    enable = lib.mkEnableOption "Enable WSL";

    windowsUsername = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = lib.mkDefault config.settings.username;
      interop.includePath = lib.mkDefault true;
    };

    environment.sessionVariables = {
      WIN_HOME_DIR = "/mnt/c/Users/${config.nixos.wsl.windowsUsername}";
    };
  };
}
