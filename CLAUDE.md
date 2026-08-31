# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal system configuration (NixOS, nix-darwin, home-manager) for Eddie Cho, managed with Nix flakes and structured as "Dendritic Nix" — every `.nix` file under `hosts/`, `modules/`, and `overlays/` is auto-discovered by convention rather than manually imported/listed.

## Commands

Commands are run via [`just`](https://github.com/casey/just) (`justfile` at repo root; provided by the flake's `devShells.default`, picked up automatically via direnv).

- `just` (default recipe, aliases to `nixos`) — rebuild and switch the system config for the current host. Runs `sudo nixos-rebuild switch` (or `darwin-rebuild switch` on macOS, chosen via `just`'s `os()` builtin) against `.#$NIXOS_FLAKE_NAME`. `$NIXOS_FLAKE_NAME` is set automatically after the first successful switch (see `environment.sessionVariables` / `environment.variables` in `lib/default.nix`), or pass it explicitly: `NIXOS_FLAKE_NAME=window just`.
- `just build` — dry-build the config (`nixos-rebuild build` / `darwin-rebuild build`) without switching. Use this to validate changes before a full switch.
- `just home <name>` — standalone home-manager switch for a `hosts/home/<system>/<name>` host (a machine with no NixOS/nix-darwin system config of its own). Not for `framework`/`window`/`work` — see `hosts/home/README.md`.
- `just fmt` — format the repo (`nix fmt .`, wired to treefmt: alejandra for Nix, stylua for Lua, shfmt for shell, jsonfmt for JSON).
- `just update` — `git pull --rebase` then `nix flake update`. Requires being on HEAD (won't update flake inputs on a dirty/behind branch).
- `just gc` / `just clean` / `just repair` — Nix store maintenance (garbage collect, delete old system generations + optimize, verify/repair store contents).
- `nix flake check` — validate the flake without building/switching; good for catching eval errors from Claude-made changes without needing sudo or a real switch.
- Host names come from the `default.nix` filename's parent directory under `hosts/<system>/<name>/` (e.g. `hosts/x86_64-linux/window` → `.#window`). List available configs with `nix flake show`.

There is no test suite; correctness is checked via `nix flake check` and `just build` (eval + build without applying).

## Architecture

**Discovery, not registration.** `lib/default.nix` provides the core helpers (`nixFiles`, `defaultFilesToAttrset`, `buildHome`, `buildNixos`, `buildDarwin`, `hosts`, `pkgsBySystem`, etc.) that everything else is built from. Adding a new host, module, or overlay is just adding a file in the right directory — nothing needs to be wired up in `flake.nix`.

- `hosts/<system>/<name>/default.nix` — one flake output per host: `nixosConfigurations.<name>` (Linux) or `darwinConfigurations.<name>` (macOS). Home-manager is always embedded as a system module here (`home-manager.users.<username> = {...}`, with `useGlobalPkgs`/`useUserPackages = true` set in `lib/default.nix`) rather than built standalone — see `window/default.nix` for the shape: `home-manager.users.<username>`, `nixos.*` module toggles, plus normal NixOS options like `networking.hostName`. Always apply changes via `just`/`just build` for these hosts, never a separate home-manager invocation: this integration is activated by a systemd service tied to the *system* generation that reruns at every boot, so a standalone home-manager profile built separately for the same host would silently get overwritten on the next reboot.
- `hosts/home/<system>/<name>/default.nix` — the standalone counterpart, for machines with no NixOS/nix-darwin system config of their own (see `hosts/home/README.md`). Produces `homeConfigurations.<name>`, applied with `just home <name>` (`buildHome` in `lib/default.nix`, no `useGlobalPkgs`/`useUserPackages`). Kept in a separate directory tree from `hosts/<system>/<name>` specifically so a name here can never collide with a system-managed host.
- `modules/nixos/`, `modules/darwin/`, `modules/home-manager/` — every `.nix` file here is auto-imported into every host of that platform (via `nixFiles` in `lib/default.nix`), so modules are almost always written as `options`-gated (`modules.<name>.enable`) rather than unconditionally applying. A host opts into a module by setting `nixos.<name>.enable = true` (or the home-manager/darwin equivalent) in its `default.nix`, not by importing the file.
- `overlays/` — every `.nix` file is applied automatically to `pkgsBySystem`, so a new overlay is just a new file (see `overlays/claude.nix` for the minimal shape: `inputs: final: prev: ...`).
- `config.json` — the only file meant to differ per-checkout/fork (username, email, fullName, stateVersion, etc.). Read via `vals = builtins.fromJSON (builtins.readFile ./config.json)` in `flake.nix` and threaded through `specialArgs` to every host/module. `just nixos`/`just darwin` run `git update-index --skip-worktree config.json` first so local edits to it don't get committed by accident.
- `static/` — Lua configs for Neovim and Hyprland, kept as plain Lua (not Nix-generated) and symlinked into `~/.config` by `just nvim` / the `hypr-luarc` recipe rather than templated through home-manager.
- `tools/` — standalone scripts exposed as flake apps (`tools.<system>.<name>`), e.g. `nix run .#tools.x86_64-linux.loadkey`.

Two host platforms exist today: `x86_64-linux` (NixOS, e.g. `window` — WSL, `framework` — bare metal with `hardware-configuration.nix`) and `aarch64-darwin` (nix-darwin, `work`).

## Notes

- Binary/font assets (`*.otf`, `*.jpg`, `*.gif`, `*.png`, `*.webm`) are tracked via Git LFS (`.gitattributes`).
- `.envrc` uses `use flake` (direnv); an optional untracked `.envrc.private` is sourced if present for machine-local env vars.
