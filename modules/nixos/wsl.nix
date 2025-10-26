{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.nixos.wsl;
in {
  options.nixos.wsl.enable = lib.mkEnableOption "Enable WSL";

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = lib.mkDefault config.settings.username;
      interop.includePath = lib.mkDefault true;
    };
  };
}
