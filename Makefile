.DEFAULT_GOAL := nixos

OS_NAME := $(shell uname -s)
ifeq ($(OS_NAME), Darwin)
	NIXOS := darwin
else
	NIXOS := nixos
endif

.PHONY: %
%:: nixos

.PHONY: gc
gc:
	nix-collect-garbage -d

.PHONY: clean
clean: gc
	sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
	nix-store --optimize

.PHONY: nvim
nvim:
	ln -sf $(shell pwd)/static/nvim $$HOME/.config

.PHONY: home
home: nvim
	home-manager switch --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: sync-nvim-to-win
sync-nvim-to-win:
ifdef WIN_HOME_DIR
	cp -r static/nvim $$WIN_HOME_DIR/AppData/Local
endif

.PHONY: nixos
nixos: nvim sync-nvim-to-win
	git update-index --skip-worktree config.json
	sudo $(NIXOS)-rebuild switch --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: build
build:
	sudo $(NIXOS)-rebuild build --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: fmt
fmt:
	nix fmt .

.PHONY: toolexample
toolexample:
	nix run .\#tools.x86_64-linux.loadkey

.PHONY: update
update:
	nix flake update

.PHONY: repair
repair:
	sudo nix-store --verify --check-contents --repair
