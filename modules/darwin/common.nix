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
      cloc
      curl
      fd
      file
      home-manager
      htop
      jq
      pkg-config
      ripgrep
      tldr
      tree
      unzip
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
        # Automatic GC intentionally disabled on Darwin — Determinate's Nix
        # daemon (see hosts/aarch64-darwin) owns its own GC schedule, and
        # nix-darwin's timer fights it. Use `nix-collect-garbage -d` or
        # `make gc` to GC manually.
        # automatic = true;
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
