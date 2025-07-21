{config, ...}: {
  home-manager.users.${config.user} = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    home.file = {
      ".config/nvim" = {
        source = ./config;
      };
    };
  };
}
