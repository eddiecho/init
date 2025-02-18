{ config, pkgs, lib, ... }: {
  config = {
    home-manager.users.${config.user} = {
      home.packages = [
        jq
	neovim
      ];
    };
  };
}
