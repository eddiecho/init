#!/bin/sh
# Claude Code runs this script for the "command" plugin source. It must print
# exactly one line on stdout: the path of the generated plugin directory.
set -eu

out="${XDG_CACHE_HOME:-$HOME/.cache}/claude-mason-lsp"
mkdir -p "$out/.claude-plugin"

# Neovim and the user config can write to stdout. Send that to stderr.
MASON_LSP_PLUGIN_JSON="$out/.claude-plugin/plugin.json" \
  nvim --headless -c "luafile $(dirname "$0")/generate.lua" -c "qa!" >&2

echo "$out"
