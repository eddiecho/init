{
  config,
  pkgs,
  lib,
  vals,
  ...
}: let
  cfg = config.modules.apps.claude;
in {
  options.modules.apps.claude = {
    enable = lib.mkEnableOption "Enable Claude Code";

    marketplaceName = lib.mkOption {
      type = lib.types.str;
      default = vals.claudeMarketplaceName;
      description = ''
        Name this system's local plugin marketplace is registered under.
        Defaults to claudeMarketplaceName in config.json; `just claude` reads
        the same key to symlink static/claude-marketplace to
        ~/.claude/<marketplaceName>-marketplace, so the two must stay in sync.
      '';
    };
  };

  # Entries under static/claude/ (CLAUDE.md, skills, commands, ...) are
  # symlinked individually into ~/.claude/
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [claude-code];

    # Claude Code writes to settings.json itself, so merge the key instead of
    # managing the file. `just claude` links the checkout's
    # static/claude-marketplace to this path before this activation runs.
    # marketplace.json is read from that same live path (not a store copy) so
    # plugin definitions can be edited without a rebuild.
    #
    # The marketplace update and plugin install/update run in this same
    # activation step, right after the registration, rather than as a
    # separate command: nixos-rebuild switch blocks on this activation
    # finishing, so anything that depends on the marketplace being registered
    # has to happen inside it to avoid racing a separate out-of-band step.
    home.activation.claudeMarketplace = lib.hm.dag.entryAfter ["writeBoundary"] ''
      marketplace="${config.home.homeDirectory}/.claude/${cfg.marketplaceName}-marketplace"
      settings="${config.home.homeDirectory}/.claude/settings.json"
      run mkdir -p "$(dirname "$settings")"
      [ -e "$settings" ] || run sh -c 'echo "{}" > "$1"' _ "$settings"
      tmp=$(mktemp)
      ${pkgs.jq}/bin/jq \
        --arg name "${cfg.marketplaceName}" \
        --arg path "$marketplace" \
        '.extraKnownMarketplaces[$name] = {source: {source: "directory", path: $path}}' \
        "$settings" > "$tmp"
      run cp "$tmp" "$settings"
      rm -f "$tmp"

      if [ -e "$marketplace/.claude-plugin/marketplace.json" ]; then
        # Plugin sources (e.g. mason-lsp's generate.sh) can shell out to
        # user-installed tools like nvim. This activation runs as a systemd
        # service with a minimal fixed PATH, so add the user's package
        # profile explicitly rather than relying on the caller's PATH.
        PATH="${config.home.profileDirectory}/bin:$PATH"
        run ${pkgs.claude-code}/bin/claude plugin marketplace update "${cfg.marketplaceName}"
        for p in $(${pkgs.jq}/bin/jq -r '.plugins[].name' "$marketplace/.claude-plugin/marketplace.json"); do
          run ${pkgs.claude-code}/bin/claude plugin install -y "$p@${cfg.marketplaceName}"
          run ${pkgs.claude-code}/bin/claude plugin update -y "$p@${cfg.marketplaceName}"
        done
      fi
    '';
  };
}
