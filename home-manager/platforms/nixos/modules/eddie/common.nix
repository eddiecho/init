{ config, pkgs, lib, ... }:

let
  inherit (config.eddie.settings) username;
  cfg = config.eddie.profiles.common;
in
{
  options.eddie.profiles.common.enable = lib.mkEnableOption "Enable common";

  config = lib.mkIf cfg.enable {

    users.mutableUsers = lib.mkDefault false;

    users.users.${username} = {
      isNormalUser = lib.mkDefault true;

      extraGroups = [
        "wheel"
      ];
    };

    environment.systemPackages = [
      pkgs.git
      pkgs.vim
      pkgs.wget
      pkgs.home-manager
      pkgs.ripgrep
    ];

    # allowUnfreePackages = true;
  };
}

