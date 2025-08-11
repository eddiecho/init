{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.apps.zsh;
in {
  options.modules.apps.zsh = {
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
