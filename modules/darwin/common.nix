{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.settings) username;
  cfg = config.darwin.common;
in {
  options.darwin.common.enable = lib.mkEnableOption "Enable common";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      curl
      fd
      file
      home-manager
      htop
      jq
      ripgrep
      tldr
      tree
      unzip
      pkg-config
      wormhole-william
    ];

    users.users.${username} = {
      name = username;
      home = "/Users/${username}";
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
