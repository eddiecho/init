#!/bin/bash

set -xe

# why do i need to install nvim if im gonna build it from source anyway?
# because it sets some env vars for you???
# idk its dumb, but it works
sudo apt-add-repository -y ppa:neovim/stable
sudo apt update
sudo apt install python3-neovim

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
mkdir -p $HOME/tools

git clone https://github.com/neovim/neovim.git $HOME/tools/neovim

pushd $HOME/tools/neovim

make CMAKE_BUILD_TYPE=Release

