.DEFAULT_GOAL := nixos

OS_NAME := $(shell uname -s)
ifeq ($(OS_NAME), Darwin)
	NIXOS := darwin
else
	NIXOS := nixos
endif

.PHONY: %
%:: nixos

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
	sudo $(NIXOS)-rebuild switch --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: build
build:
	sudo nixos-rebuild build --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: fmt
fmt:
	nix fmt .

.PHONY: sync-nvim-to-win
sync-nvim-to-win:
	cp -r static/nvim $$WIN_HOME_DIR/AppData/Local

.PHONY: toolexample
toolexample:
	nix run .\#tools.x86_64-linux.loadkey

.PHONY: update
update:
	nix flake update

.PHONY: repair
repair:
	sudo nix-store --verify --check-contents --repair
