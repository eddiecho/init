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

.PHONY: hypr-luarc
hypr-luarc:
	@if [ -e "$$HOME/.config/hypr/.luarc.json" ]; then \
		ln -sfn $$HOME/.config/hypr/.luarc.json $(shell pwd)/static/hypr/.luarc.json; \
	else \
		rm -f $(shell pwd)/static/hypr/.luarc.json; \
	fi

.PHONY: sync-nvim-to-win
sync-nvim-to-win:
ifdef WIN_HOME_DIR
	cp -r static/nvim $$WIN_HOME_DIR/AppData/Local
endif

# TODO - maybe just switch to just so we can have proper dependency tracking
.PHONY: nixos
nixos: nvim sync-nvim-to-win
	git update-index --skip-worktree config.json
	sudo $(NIXOS)-rebuild switch --flake .\#$$NIXOS_FLAKE_NAME
	$(MAKE) hypr-luarc

.PHONY: build
build:
	sudo $(NIXOS)-rebuild build --flake .\#$$NIXOS_FLAKE_NAME

.PHONY: fmt
fmt:
	nix fmt .

.PHONY: home
home:
ifndef HOME_CONFIG
	$(error HOME_CONFIG is not set — pass the hosts/home/<system>/<name> host name, e.g. `make home HOME_CONFIG=laptop`. See hosts/home/README.md)
endif
	home-manager switch --flake .\#$(HOME_CONFIG)

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
