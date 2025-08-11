#!/bin/bash

FLAKE_NAME=$1

exists() {
	command -v $1 2>&1 >/dev/null
}

# install nix
if ! exists nix
then
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

if [[ -n $(uname -a | grep nixos) ]]; then
  sudo nixos-rebuild switch --flake .#$FLAKE_NAME
else
	# install home-manager
	nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
	nix-channel --update
	# this should also install the home-manager config and set everything up
	nix-shell '<home-manager>' -A install
	# absolute retardation
	nix flake --extra-experimental-features 'nix-command flakes' update
fi

home-manager switch --flake .#$FLAKE_NAME
