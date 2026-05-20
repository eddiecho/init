{
  config,
  pkgs,
  lib,
  root,
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

      withRuby = false;
      withPython3 = false;
    };

    # Out-of-store symlink so edits in static/nvim/ take effect without
    # `home-manager switch`. Mirrors the pattern used for Hyprland.
    home.file.".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink
      (builtins.toPath "${root}/static/nvim");

    home.packages = with pkgs; [
      tree-sitter
    ];

    programs.git.settings.core.editor = lib.mkForce "${lib.getExe cfg.package}";

    home.sessionVariables = {
      EDITOR = lib.mkDefault "${lib.getExe cfg.package}";
      MANPAGER = lib.mkDefault "${lib.getExe cfg.package} +Man!";
    };
  };
}
