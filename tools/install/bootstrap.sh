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

if [[ $(uname -s) -eq "Darwin" ]]; then
  darwin-rebuild switch --flake. .#$FLAKE_NAME
else
  nixo-rebuild switch --flake .#$FLAKE_NAME
fi
