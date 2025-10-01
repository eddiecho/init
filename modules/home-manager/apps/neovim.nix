{
  config,
  pkgs,
  root,
  lib,
  ...
}: let
  cfg = config.modules.apps.neovim;
in {
  options.modules.apps.neovim = {
    enable = lib.mkEnableOption "Enable neovim";
    package = lib.mkPackageOption pkgs "neovim" {};
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    home.packages = with pkgs; [
      nixd
    ];

    programs.git.extraConfig.core.editor = lib.mkForce "${lib.getExe cfg.package}";

    home.sessionVariables = {
      EDITOR = lib.mkDefault "${lib.getExe cfg.package}";
      MANPAGER = lib.mkDefault "${lib.getExe cfg.package} +Man!";
    };

    home.file = {
      ".config/nvim" = {
        source = builtins.toPath "${root}/static/nvim";
      };
    };
  };
}
