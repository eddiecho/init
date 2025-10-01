all: nixos

.PHONY: clean
clean:
	sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
	nix-collect-garbage -d
	nix-store --optimize

.PHONY: gc
gc:
	nix-collect-garbage -d

.PHONY: home
home:
	home-manager switch --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: nixos
nixos:
	sudo nixos-rebuild switch --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: fmt
fmt:
	nix fmt .

# This rule acts as both the catch-all as well as the 'all' which is the typical default top-level rule
.PHONY: %
%:: nixos

.PHONY: sync-nvim-to-win
sync-nvim-to-win:
	cp -r static/nvim /mnt/c/Users/photo/AppData/Local

.PHONY: toolexample
toolexample:
	nix run .\#tools.x86_64-linux.loadkey
