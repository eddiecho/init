{
  config,
  pkgs,
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

      withRuby = false;
      withPython3 = false;

      # Keep HM from writing ~/.config/nvim/init.lua — it auto-merges
      # wrappedNeovim'.luaRcContent into initLua, which conflicts with
      # our Makefile-managed symlink to static/nvim/. With sideloadInitLua
      # the wrapper passes its init via `nvim -u <path>` instead.
      sideloadInitLua = true;
    };

    # NOTE: ~/.config/nvim is symlinked to static/nvim/ by the `nvim` target
    # in the top-level Makefile, not by home-manager. mkOutOfStoreSymlink
    # routes through /nix/store/ which is read-only and blocks nvim's
    # plugin lockfile writes; a `home.activation` ln also did not work.

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
