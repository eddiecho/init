# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal system configuration (NixOS, nix-darwin, home-manager) for Eddie Cho, managed with Nix flakes and structured as "Dendritic Nix" — every `.nix` file under `hosts/`, `modules/`, and `overlays/` is auto-discovered by convention rather than manually imported/listed.

## Commands

- `make` (default target, aliases to `nixos`/`darwin` depending on OS) — rebuild and switch the system config for the current host. Runs `sudo nixos-rebuild switch` (or `darwin-rebuild switch`) against `.#$NIXOS_FLAKE_NAME`. `$NIXOS_FLAKE_NAME` is set automatically after the first successful switch (see `environment.sessionVariables` / `environment.variables` in `lib/default.nix`), or pass it explicitly: `NIXOS_FLAKE_NAME=window make`.
- `make build` — dry-build the config (`nixos-rebuild build` / `darwin-rebuild build`) without switching. Use this to validate changes before a full switch.
- `make home` — home-manager-only switch (`home-manager switch --flake .#$NIXOS_FLAKE_NAME`), for machines not fully managed by this flake's NixOS/Darwin config.
- `make fmt` — format the repo (`nix fmt .`, wired to treefmt: alejandra for Nix, stylua for Lua, shfmt for shell, jsonfmt for JSON).
- `make update` — `git pull --rebase` then `nix flake update`. Requires being on HEAD (won't update flake inputs on a dirty/behind branch).
- `make gc` / `make clean` / `make repair` — Nix store maintenance (garbage collect, delete old system generations + optimize, verify/repair store contents).
- `nix flake check` — validate the flake without building/switching; good for catching eval errors from Claude-made changes without needing sudo or a real switch.
- Host names come from the `default.nix` filename's parent directory under `hosts/<system>/<name>/` (e.g. `hosts/x86_64-linux/window` → `.#window`). List available configs with `nix flake show`.

There is no test suite; correctness is checked via `nix flake check` and `make build` (eval + build without applying).

## Architecture

**Discovery, not registration.** `lib/default.nix` provides the core helpers (`nixFiles`, `defaultFilesToAttrset`, `buildHome`, `buildNixos`, `buildDarwin`, `hosts`, `pkgsBySystem`, etc.) that everything else is built from. Adding a new host, module, or overlay is just adding a file in the right directory — nothing needs to be wired up in `flake.nix`.

- `hosts/<system>/<name>/default.nix` — one flake output per host. `lib.hosts` walks this tree and turns each subdirectory into a named config (`nixosConfigurations.<name>`, `darwinConfigurations.<name>`, or a home-manager user config, depending on which attrs the file sets — see `window/default.nix` for the shape: `home-manager.users.<username>`, `nixos.*` module toggles, plus normal NixOS options like `networking.hostName`).
- `modules/nixos/`, `modules/darwin/`, `modules/home-manager/` — every `.nix` file here is auto-imported into every host of that platform (via `nixFiles` in `lib/default.nix`), so modules are almost always written as `options`-gated (`modules.<name>.enable`) rather than unconditionally applying. A host opts into a module by setting `nixos.<name>.enable = true` (or the home-manager/darwin equivalent) in its `default.nix`, not by importing the file.
- `overlays/` — every `.nix` file is applied automatically to `pkgsBySystem`, so a new overlay is just a new file (see `overlays/claude.nix` for the minimal shape: `inputs: final: prev: ...`).
- `config.json` — the only file meant to differ per-checkout/fork (username, email, fullName, stateVersion, etc.). Read via `vals = builtins.fromJSON (builtins.readFile ./config.json)` in `flake.nix` and threaded through `specialArgs` to every host/module. `make nixos`/`make home` run `git update-index --skip-worktree config.json` first so local edits to it don't get committed by accident.
- `static/` — Lua configs for Neovim and Hyprland, kept as plain Lua (not Nix-generated) and symlinked into `~/.config` by `make nvim` / the `hypr-luarc` target rather than templated through home-manager.
- `tools/` — standalone scripts exposed as flake apps (`tools.<system>.<name>`), e.g. `nix run .#tools.x86_64-linux.loadkey`.

Two host platforms exist today: `x86_64-linux` (NixOS, e.g. `window` — WSL, `framework` — bare metal with `hardware-configuration.nix`) and `aarch64-darwin` (nix-darwin, `work`).

## Notes

- Binary/font assets (`*.otf`, `*.jpg`, `*.gif`, `*.png`, `*.webm`) are tracked via Git LFS (`.gitattributes`).
- `.envrc` uses `use flake` (direnv); an optional untracked `.envrc.private` is sourced if present for machine-local env vars.
