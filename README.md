# System configurations for my stuff

Mostly managed by [Nix](https://nixos.org) and inspired by Dendritic Nix.

# How it works

The library functions `buildHome`, `buildNixos`, and `buildDarwin` will crawl through the `hosts` directory to find any `default.nix` files and use those as input modules. For example, `hosts/x86_64-linux/window/default.nix` will create a flake named `window`, and use the configurations defined there. If you want to use that one, then you can do `nixos-rebuild switch --flake .#window`. `nixos-rebuild switch` will also save the flake name you used to `$NIXOS_FLAKE_NAME`. After that a simple `make` will suffice.

`modules` defines the options for setting up applications. Generally, `modules/home-manager` is for user level stuff, while `modules/nixos` and `modules/darwin` are for system level stuff.

`static` has static assets. In particular it has my Neovim and Hyprland configurations, both as Lua. Those two both get symlinked into `~/.config`. I think it's better than writing Lua in Nix, and the source of truth is always the local copy of this repo.

`tools` has random one-off scripts, including a bootstrap installer (which as of 12/01/2025 I still haven't tested).

If for whatever reason someone else decides to copy this, just update the values in config.json and you should be fine. Remember to add your own hardware-configuration.nix files to the hosts.
