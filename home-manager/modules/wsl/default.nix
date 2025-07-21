{ config, pkgs, lib, ... }:

let
  inherit (config.settings) username;
  cfg = config.mixins.wsl;
in
{
  options.mixins.wsl.enable = lib.mkEnableOption "Enable WSL";
  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
      defaultUser = lib.mkDefault username;
    };
  };
}
