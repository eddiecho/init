#!/bin/bash

set -e

CURR_DIR=$(pwd)
TOOLS_DIR=$HOME/tools
[ -d $TOOLS_DIR ] || mkdir -p $TOOLS_DIR

git config --global user.email "eunseocho@gmail.com"
git config --global user.name "Edward Cho"
git config --global --replace-all core.pager "less -F -X"
git config --global core.editor "nvim"

sudo apt update
sudo apt-get install \
  ninja-build \
  gettext \
  libtool \
  libtool-bin \
  autoconf \
  automake \
  cmake \
  g++ \
  pkg-config \
  unzip

if [[ -z $(which brew) ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/eddie/.profile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew install tldr
brew install tree
brew install cloc
brew install zsh
brew install python

if [[ -d $TOOLS_DIR/neovim ]]; then
  echo "skipping neovim install"
else
  git clone https://github.com/neovim/neovim.git $TOOLS_DIR/neovim

  pushd $TOOLS_DIR/neovim
  make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local
  sudo make install
  popd

fi

python3 -m pip install -U neovim pynvim

if [[ -h ~/.config/nvim ]]; then
  echo ""
else
  mkdir -p ~/.config
  ln -s $CURR_DIR/nvim ~/.config/nvim
fi

echo "yay done"
echo "things to do after:"
echo "   sudo chsh -s /bin/zsh"
echo "   ./scripts/oh_my_zsh.sh"
