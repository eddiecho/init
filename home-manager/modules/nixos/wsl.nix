{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.settings) username;
  cfg = config.nixos.wsl;
in {
  options.nixos.wsl.enable = lib.mkEnableOption "Enable WSL";

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = lib.mkDefault username;
      interop.includePath = lib.mkDefault false;
    };
  };
}
