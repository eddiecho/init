{
  config,
  root,
  lib,
  ...
}: let
  cfg = config.modules.apps.claude;
in {
  options.modules.apps.claude = {
    enable = lib.mkEnableOption "Enable Claude Code global config";
  };

  config = lib.mkIf cfg.enable {
    home.file.".claude/CLAUDE.md" = {
      source =
        config.lib.file.mkOutOfStoreSymlink
        (builtins.toPath "${root}/static/claude/CLAUDE.md");
    };
  };
}
