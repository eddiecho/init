nixos_cmd := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }

default: nixos

gc:
    nix-collect-garbage -d

clean: gc
    sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
    nix-store --optimize

nvim:
    git update-index --skip-worktree static/nvim/nvim-pack-lock.json
    ln -sfn {{ justfile_directory() }}/static/nvim ~/.config/nvim

claude:
    #!/usr/bin/env bash
    mkdir -p "$HOME/.claude"
    # we do this per file because claude dumps a ton of stuff by default
    for f in {{ justfile_directory() }}/static/claude/*; do
        ln -sfn "$f" "$HOME/.claude/$(basename "$f")"
    done
    ln -sfn {{ justfile_directory() }}/static/claude-marketplace "$HOME/.claude/init-marketplace"
    # The claude home-manager module registers the marketplace. Run `just` before this recipe.
    claude plugin marketplace update init
    for p in $(jq -r '.plugins[].name' {{ justfile_directory() }}/static/claude-marketplace/.claude-plugin/marketplace.json); do
        claude plugin install -y "$p@init"
        claude plugin update -y "$p@init"
    done

wallpaper_id := replace_regex(read(justfile_directory() / "static/hypr/parts/wallpaper.lua"), '(?s).*return "([0-9]+)".*', '$1')

# Download Wallpaper Engine (for its assets folder) and the wallpaper set in
# static/hypr/parts/wallpaper.lua. The steamUsername account in config.json
# must own Wallpaper Engine.
wallpaper:
    #!/usr/bin/env bash
    set -euo pipefail
    user=$(jq -r '.steamUsername // ""' "{{ justfile_directory() }}/config.json")
    if [ -z "$user" ]; then
        echo "error: set steamUsername in config.json" >&2
        exit 1
    fi
    steamcmd +@sSteamCmdForcePlatformType windows +login "$user" +app_update 431960 +workshop_download_item 431960 {{ wallpaper_id }} +quit

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

nixos: nvim claude sync-nvim-to-win && hypr-luarc
    git update-index --skip-worktree config.json
    sudo env "PATH=$PATH" {{ nixos_cmd }} switch --flake .#${NIXOS_FLAKE_NAME}

build:
    sudo env "PATH=$PATH" {{ nixos_cmd }} build --flake .#${NIXOS_FLAKE_NAME}

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
