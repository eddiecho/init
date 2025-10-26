# System configurations for my stuff

Mostly managed by [Nix](https://nixos.org) and heavily inspired by [https://github.com/nmasur/dotfiles].

# How it works

The library functions `buildHome`, `buildNixos`, and `buildDarwin` will crawl through the `hosts` directory to find any `default.nix` files and use those as inputs. For example, `hosts/x86_64-linux/window/default.nix` will create a flake named `window`, and use the configurations defined there.

`modules` defines the options for setting up applications. Generally, `modules/home-manager` is for user level stuff, and `modules/nixos` and `modules/darwin` are for system level stuff.

`static` has static assets. Most notably, it contains my Neovim config, which is simply symlinked into `~/.config`. I don't know, I don't feel like rewriting it into Nix.

`tools` has random one-off scripts.

If for whatever reason someone else decides to copy this, just update the values in config.json and you should be fine. Remember to add your own hardware-configuration.nix files to the hosts.
