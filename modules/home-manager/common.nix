{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.common;
in {
  options.modules.common.enable = lib.mkEnableOption "Enable base";

  config = lib.mkIf cfg.enable {
    news.display = "silent";

    home.username = config.settings.username;
    home.homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.settings.username}"
      else "/home/${config.settings.username}";

    home.packages = with pkgs; [
      nodejs_22 # I think Mason.nvim uses this? Maybe just be better to add LSPs manually in nix
    ];

    modules.apps = {
      neovim.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      direnv.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
    };
  };
}
