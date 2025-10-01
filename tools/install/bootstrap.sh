#!/usr/bin/env bash

# only for non-nixos systems...

FLAKE_NAME=$1

exists() {
  command -v $1 2>&1 >/dev/null
}

# install nix
if ! exists nix; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

if ! exists home-manager; then
  nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
  nix flake --extra-experimental-features 'nix-command flakes' update
fi

home-manager switch --flake .#$FLAKE_NAME
