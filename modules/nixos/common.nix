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
      shell = pkgs.zsh;
      isNormalUser = lib.mkDefault true;
      extraGroups = ["networkmanager" "wheel"];
    };

    environment.systemPackages = with pkgs; [
      curl
      fd
      file
      git-lfs
      home-manager
      htop
      hwinfo
      jq
      pkg-config
      ripgrep
      tldr
      tree
      unzip
      wormhole-william
    ];

    programs = {
      zsh.enable = true;

      # FUCK YOU
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          openssl
        ];
      };
    };

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
        trusted-users = [
          "root"
          "@wheel"
          username
        ];

        allowed-users = [
          "@wheel"
          username
        ];

        auto-optimise-store = lib.mkIf (!pkgs.stdenv.isDarwin) true;
      };
    };
  };
}
