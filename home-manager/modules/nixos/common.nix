{ config, pkgs, lib, ... }:

let
  inherit (config.settings) username;
  cfg = config.mixins.common;
in
{
  options.mixins.common.enable = lib.mkEnableOption "Enable common";

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

