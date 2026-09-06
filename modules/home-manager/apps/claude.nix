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
  # symlinked individually into ~/.claude/ by the `claude` target in the
  # top-level justfile, not by home-manager: ~/.claude also holds runtime
  # state (sessions, memory, settings.local.json) that must stay unmanaged.
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ claude-code ];
  };
}
