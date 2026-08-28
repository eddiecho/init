#!/usr/bin/env bash

# only for non-nixos systems...

set -euo pipefail

MODE="system"
if [[ ${1:-} == "--home" ]]; then
  MODE="home"
  shift
fi

FLAKE_NAME=${1:?usage: bootstrap.sh [--home] <flake-name>}

exists() {
  command -v "$1" >/dev/null 2>&1
}

# install nix
if ! exists nix; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

if [[ $MODE == "home" ]]; then
  # standalone home-manager, no system config to switch — see hosts/home/README.md.
  # home-manager isn't installed yet on a fresh machine, so run the
  # activation package directly through nix rather than `home-manager switch`.
  nix run ".#homeConfigurations.$FLAKE_NAME.activationPackage"
elif [[ $(uname -s) == "Darwin" ]]; then
  darwin-rebuild switch --flake ".#$FLAKE_NAME"
else
  nixos-rebuild switch --flake ".#$FLAKE_NAME"
fi
