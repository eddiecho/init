#!/bin/bash

set -x

pushd ~/tools/neovim

git pull
rm -rf build
sudo make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local install
nvim --version

popd
