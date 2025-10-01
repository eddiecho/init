.PHONY clear-generations
clear-generations:
	nix-env --delete-generations old --profile /nix/var/nix/profiles/system

.PHONY gc
gc:
	nix-collect-garbage -d

.PHONY home
home:
	home-manager switch --flake .$#$$NIXOS_FLAKE_NAME

.PHONY nixos
nixos:
	sudo nixos-rebuild switch --flake .$#$$NIXOS_FLAKE_NAME

# This rule acts as both the catch-all as well as the 'all' which is the typical default top-level rule
.PHONY %
%:: nixos

all:: nixos

