# CLAUDE.md

Global guidance for Claude Code across all of Eddie Cho's projects.

## Environment

- Machines are managed by a Nix flake (NixOS on Linux, nix-darwin on
  macOS, home-manager for user config). Prefer editing that flake's
  modules over imperative installs (`nix-env -i`, `brew install`,
  `apt install`); for a one-off tool, `nix shell nixpkgs#<pkg>` or
  `nix run nixpkgs#<pkg>` is usually the right ask rather than a
  permanent install.
- Shell is zsh (oh-my-zsh) with tmux (prefix `C-Space`, vi copy-mode).
- Editor/`$EDITOR` is Neovim, config in Lua.
- `git diff` is difftastic (`difft`); expect structural, not line-based,
  diff output when reviewing changes.

## Git conventions

- History is kept rebase-clean: `pull.rebase`, `rebase.autoStash`, and
  `rebase.autoSquash` are all on, `push.default` is `current` with
  `autoSetupRemote`. Prefer `fixup!`/`squash!` commits over amending
  shared history, and don't add merge commits where a rebase works.
- `commit.cleanup = scissors` — trailing comment lines in a commit
  message template are stripped, don't rely on them surviving.
- `merge.conflictstyle = diff3` — conflict markers include the common
  ancestor hunk; use it to understand *why* sides diverged, not just
  *what* they changed.
