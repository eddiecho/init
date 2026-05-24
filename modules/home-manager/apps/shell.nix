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

      history = {
        size = 1000000;
        save = 1000000;
        extended = true; # EXTENDED_HISTORY — record timestamps per entry
        ignoreSpace = true; # bash: HISTCONTROL ignorespace / HISTIGNORE "[ ]*"
        ignoreDups = true; # bash: HISTCONTROL ignoredups
        ignoreAllDups = true; # bash: HISTCONTROL erasedups
        expireDuplicatesFirst = true;
        ignorePatterns = [
          "exit"
          "ls"
          "bg"
          "fg"
          "history"
          "clear"
        ];
      };

      initContent = ''
        # Flush each command to $HISTFILE as it's run (bash equivalent:
        # PROMPT_COMMAND="history -a..."). Without sharing across live shells.
        setopt INC_APPEND_HISTORY
      '';

      # Substring-match history search on up/down arrows. The plugin binds
      # ^[[A / ^[[B by default.
      historySubstringSearch.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "gallifrey";
        plugins = ["git"];
      };
    };
  };
}
