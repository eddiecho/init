.DEFAULT_GOAL := nixos

OS_NAME := $(shell uname -s)
ifeq ($(OS_NAME), Darwin)
	NIXOS := darwin
else
	NIXOS := nixos
endif

.PHONY: gc
gc:
	nix-collect-garbage -d

.PHONY: clean
clean: gc
	sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
	nix-store --optimize

.PHONY: nvim
nvim:
	ln -sfn $(shell pwd)/static/nvim $$HOME/.config/nvim

# Lets lua-ls in static/hypr/parts/*.lua pick up the Hyprland stubs that
# HM (configType = "lua") writes per current Hyprland version. Dangling on
# machines without Hyprland — lua-ls treats a missing target as no config.
.PHONY: hypr-luarc
hypr-luarc:
	ln -sfn $$HOME/.config/hypr/.luarc.json $(shell pwd)/static/hypr/.luarc.json

.PHONY: home
home: nvim hypr-luarc
	home-manager switch --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: sync-nvim-to-win
sync-nvim-to-win:
ifdef WIN_HOME_DIR
	cp -r static/nvim $$WIN_HOME_DIR/AppData/Local
endif

# TODO - maybe just switch to just so we can have proper dependency tracking
.PHONY: nixos
nixos: nvim hypr-luarc sync-nvim-to-win
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
	# no updates without being on HEAD
	git pull --rebase
	nix flake update

.PHONY: repair
repair:
	sudo nix-store --verify --check-contents --repair
