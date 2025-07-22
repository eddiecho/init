{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.settings) username;
  cfg = config.nixos.common;
in {
  options.nixos.common.enable = lib.mkEnableOption "Enable common";

  config = lib.mkIf cfg.enable {
    users.mutableUsers = lib.mkDefault false;

    users.users.${username} = {
      isNormalUser = lib.mkDefault true;

      extraGroups = ["wheel"];
    };

    environment.systemPackages = with pkgs; [
      git
      neovim
      curl
      home-manager
      ripgrep
      fd
      jq
      htop
      unzip
      file
    ];

    nix = {
      extraOptions = ''
        experimental-features = nix-command flakes
        warn-dirty = false
      '';

      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };

      settings = {
        auto-optimise-store = lib.mkIf (!pkgs.stdenv.isDarwin) true;
      };
    };

    wsl.enable = lib.mkDefault false;
  };
}
