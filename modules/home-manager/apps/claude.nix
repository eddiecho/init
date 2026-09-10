{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.apps.claude;
in {
  options.modules.apps.claude = {
    enable = lib.mkEnableOption "Enable Claude Code";
  };

  # Entries under static/claude/ (CLAUDE.md, skills, commands, ...) are
  # symlinked individually into ~/.claude/
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [claude-code];
  };
}
