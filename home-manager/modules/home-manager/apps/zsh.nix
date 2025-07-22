{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.hm.apps.zsh;
in {
  options.hm.apps.zsh = {
    enable = lib.mkEnableOption "Enable zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      shellAliases = {
        nvimswaps = "pushd; cd ~/.local/state/nvim/swap";
        hms = "home-manager switch --flake ~/.config/home-manager --show-trace";
      };

      oh-my-zsh = {
        enable = true;
        theme = "gallifrey";
        plugins = ["git"];
      };
    };
  };
}
