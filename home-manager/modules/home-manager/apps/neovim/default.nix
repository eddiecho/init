{ config, pkgs, lib, ... }:
let
  cfg = config.hm.apps.neovim;
in
{
  options.hm.apps.neovim = {
    enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      home.file = {
        ".config/nvim" = {
          source = ./config
        };
      };
    };

    programs.git.extraConfig.core.editor = "${lib.getExe cfg.package}";

    home.sessionVariables = {
      EDITOR = "${lib.getExe cfg.package}";
      MANPAGER = "${lib.getExe cfg.package} +Man!";
    };
  };
}

