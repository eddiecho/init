{ config, pkgs, lib, ... }:

let
  cfg = config.eddie.profiles.common;
in
{
  options.eddie.profiles.common.enable = lib.mkEnableOption "Enable base";

  config = lib.mkIf cfg.enable {
    news.display = "silent";

    home.username = config.eddie.settings.username;
    home.homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
  }
}

