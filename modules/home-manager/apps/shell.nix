{
  config,
  lib,
  ...
}: let
  cfg = config.modules.apps.shell;
in {
  options.modules.apps.shell = {
    enable = lib.mkEnableOption "Enable shell config";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      shellAliases = {
        nvimswaps = "pushd; cd ~/.local/state/nvim/swap";
      };

      oh-my-zsh = {
        enable = true;
        theme = "gallifrey";
        plugins = ["git"];
      };
    };
  };
}
