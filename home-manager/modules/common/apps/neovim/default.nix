{ lib, config, ... }:
{
  home-manager.home.${config.user} = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
  };

  home.file.neovim.source = lib.file.mkOutOfStoreSymlink ./config;
}
