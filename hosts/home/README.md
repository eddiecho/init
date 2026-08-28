# Standalone home-manager hosts

This directory is for machines that **don't** run this flake's NixOS or
nix-darwin system config — a work laptop you don't have root on, a plain
Linux distro, unmanaged macOS, WSL without NixOS-WSL, a container, etc.
Home-manager runs there as an ordinary user-level program, entirely
independent of any system config.

**Do not** add a host here for `framework`, `window`, or `work` (or any
future host under `hosts/x86_64-linux/` or `hosts/aarch64-darwin/`). Those
already get home-manager as part of their NixOS/nix-darwin system build.
Adding a same-named standalone config on top would give that user two
disconnected home-manager profiles fighting over the same dotfiles, and
only the system-managed one survives a reboot (`home-manager-<user>.service`
re-activates whatever the last system generation built, every boot,
silently reverting anything applied only through the standalone path). If
you're not sure which one you need: if the machine already shows up under
`hosts/<system>/<name>/`, you don't need anything in here for it.

## Adding a new one

Create `hosts/home/<system>/<name>/default.nix`, where `<system>` is
`x86_64-linux` or `aarch64-darwin` and `<name>` is anything not already
used by a host under `hosts/<system>/` on that same system. Keep it to
plain home-manager options — no `nixos.*`, no `darwin.*`, no `boot`, no
`networking.hostName`:

```nix
# hosts/home/x86_64-linux/laptop/default.nix
{vals, ...}: {
  settings = {
    username = vals.username;
    fullName = vals.fullName;
    email = vals.email;
    anonEmail = vals.anonEmail;
    anonName = vals.anonName;
  };

  modules = {
    common.enable = true;

    apps = {
      # pick whichever modules/home-manager/apps/*.nix modules make sense
      # for this machine — e.g. tmux.enable = true;
    };
  };

  home.stateVersion = vals.stateVersion;
}
```

This produces a `homeConfigurations.<name>` flake output.

## Commands

First switch on a fresh machine (no home-manager installed yet — this
builds and runs the activation script directly through Nix, no separate
install needed):

```
nix run .#homeConfigurations.<name>.activationPackage
```

If Nix itself isn't installed yet either, `tools/install/bootstrap.sh --home <name>`
does both steps: installs Nix if missing, then runs the activation package
above. See `tools/install/bootstrap.sh`.

Every switch after that:

```
make home HOME_CONFIG=<name>
```

which just runs `home-manager switch --flake .#<name>`. `HOME_CONFIG` is
required on purpose — there's no ambient `$NIXOS_FLAKE_NAME` fallback here,
so you always have to name the target explicitly.

Generations/rollback for this profile are independent of any system
generation:

```
home-manager generations
home-manager rollback
```
