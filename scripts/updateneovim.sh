#!/bin/bash

set -x

pushd ~/tools

rm -rf neovim
git clone git@github.com:neovim/neovim --depth 1

make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local
sudo make install

nvim --version

popd
