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
      nodejs_22 # required by mason for npm-based LSPs (pyright, ts_ls, bashls)
      clang_21 # tree-sitter uses this
      cargo
    ];

    modules.apps = {
      neovim.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      direnv.enable = lib.mkDefault true;
      shell.enable = lib.mkDefault true;
    };
  };
}
