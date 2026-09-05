nixos_cmd := if os() == "macos" { "darwin" } else { "nixos" }

default: nixos

gc:
    nix-collect-garbage -d

clean: gc
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
    nix-store --optimize

nvim:
    ln -sfn {{ justfile_directory() }}/static/nvim ~/.config/nvim

hypr-luarc:
    #!/usr/bin/env bash
    if [ -e "$HOME/.config/hypr/.luarc.json" ]; then
        ln -sfn "$HOME/.config/hypr/.luarc.json" "{{ justfile_directory() }}/static/hypr/.luarc.json"
    else
        rm -f "{{ justfile_directory() }}/static/hypr/.luarc.json"
    fi

sync-nvim-to-win:
    #!/usr/bin/env bash
    if [ -n "${WIN_HOME_DIR:-}" ]; then
        cp -r static/nvim "$WIN_HOME_DIR/AppData/Local"
    fi

nixos: nvim sync-nvim-to-win && hypr-luarc
    git update-index --skip-worktree config.json
    sudo {{ nixos_cmd }}-rebuild switch --flake .#${NIXOS_FLAKE_NAME}

build:
    sudo {{ nixos_cmd }}-rebuild build --flake .#${NIXOS_FLAKE_NAME}

fmt:
    nix fmt .

# Standalone home-manager only — for hosts/home/<system>/<name> machines
# with no NixOS/darwin system config of their own. See hosts/home/README.md.
home HOME_CONFIG:
    home-manager switch --flake .#{{ HOME_CONFIG }}

run TOOL_NAME:
    nix run .#tools.x86_64-linux.${{ TOOL_NAME }}

# no updates without being on HEAD
update:
    git pull --rebase
    nix flake update

repair:
    sudo nix-store --verify --check-contents --repair
