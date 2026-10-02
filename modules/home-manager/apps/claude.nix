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

    # Claude Code writes to settings.json itself, so merge the key instead of
    # managing the file. `just claude` links the checkout's
    # static/claude-marketplace to this path. marketplace.json references the
    # same path, so the plugins run from the checkout and not the store copy.
    home.activation.claudeMarketplace = lib.hm.dag.entryAfter ["writeBoundary"] ''
      settings="${config.home.homeDirectory}/.claude/settings.json"
      run mkdir -p "$(dirname "$settings")"
      [ -e "$settings" ] || run sh -c 'echo "{}" > "$1"' _ "$settings"
      tmp=$(mktemp)
      ${pkgs.jq}/bin/jq \
        --arg path "${config.home.homeDirectory}/.claude/init-marketplace" \
        '.extraKnownMarketplaces.init = {source: {source: "directory", path: $path}}' \
        "$settings" > "$tmp"
      run cp "$tmp" "$settings"
      rm -f "$tmp"
    '';
  };
}
