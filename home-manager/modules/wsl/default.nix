{ config, pkgs, lib, ... }:

let
  cfg = config.eddie.profiles;
in
{
  options.eddie.profiles.wsl.enable = lib.mkEnableOption "Enable WSL";
  config = lib.mkIf cfg.wsl.enable {

  };
}
