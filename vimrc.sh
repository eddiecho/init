#!/bin/bash

set -xe

mkdir -p $HOME/.config/nvim
git clone https://github.com/eddiecho/vimrc.git $HOME/.config/nvim

git clone https://github.com/neovim/neovim.git $HOME/tools/nvim

sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

pushd ~/tools/nvim
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/usr/bin" CMAKE_BUILD_TYPE=Release
sudo make install

curl -fLo ~/.var/app/io.neovim.nvim/data/nvim/site/autoload/plug.vim \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

pip install -U neovim pynvim

export PATH="$HOME/tools/nvim/build/bin:$PATH"

