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

    # Direct symlink (not mkOutOfStoreSymlink) so writes through ~/.config/nvim
    # land in static/nvim/ — nvim's plugin lock file lives there and must be
    # writable. mkOutOfStoreSymlink routes through /nix/store/ which is mounted
    # read-only on macOS (and typically on NixOS), blocking the write.
    home.activation.linkNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ln $VERBOSE_ARG -sfn ${toString root}/static/nvim $HOME/.config/nvim
    '';

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
