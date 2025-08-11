#!/bin/bash

exists() {
	command -v $1 2>&1 >/dev/null
}

# install nix
if ! exists nix
then
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

if ! exists home-manager
then
	# install home-manager
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	# this should also install the home-manager config and set everything up
	nix-shell '<home-manager>' -A install
	# absolute retardation
	nix flake --extra-experimental-features 'nix-command flakes' update
fi

if 0; then
	# install neovim
	git clone --depth 1 git@github.com:neovim/neovim
	pushd neovim
	make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local
	sudo make install
	popd
fi
