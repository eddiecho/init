#!/bin/bash

set -x

CURR_DIR=$(pwd)
TOOLS_DIR=$HOME/tools
[ -d $TOOLS_DIR ] || mkdir -p $TOOLS_DIR

if [[ $USER == "edcho" ]]; then
  git config --global user.email "edcho@amazon.com"
else
  git config --global user.email "eunseocho@gmail.com"
fi
git config --global user.name "Edward Cho"
git config --global --replace-all core.pager "less -F -X"
git config --global core.editor "nvim"

function install_deps {
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
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/$USER/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  brew install tldr
  brew install tree
  brew install cloc
  brew install zsh
  brew install rg
  brew install zig --HEAD
  brew install tmux
}

function install_zsh {
  if [[ -z $(grep zsh /etc/shells) ]]; then
    which zsh | sudo tee -a /etc/shells
  fi
}

function install_npm {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

  if [[ -z $(grep NVM_DIR ~/.zshrc) ]]; then
    echo 'export NVM_DIR="$HOME/.nvm"' | ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' | ~/.zshrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' | ~/.zshrc
  fi
}

function install_rust {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs --output $CURR_DIR/tmp/rustup.sh
  chmod +x $CURR_DIR/tmp/rustup.sh
  sh $CURR_DIR/tmp/rustup.sh
}

function install_nvim {
  python3 -m pip install -U neovim pynvim

  if [[ -d $TOOLS_DIR/neovim ]]; then
    echo "skipping neovim install"
  else
    git clone https://github.com/neovim/neovim.git $TOOLS_DIR/neovim

    pushd $TOOLS_DIR/neovim
    make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local
    sudo make install
    popd
  fi

  if [[ -h ~/.config/nvim ]]; then
    echo ""
  else
    mkdir -p ~/.config
    ln -s $CURR_DIR/nvimconf ~/.config/nvim
  fi
}

function install_tmux {
  if [[ -h ~/.config/tmux ]]; then
    echo ""
  else
    mkdir -p ~/.config
    ln -s $CURR_DIR/tmuxconf ~/.config/tmux
  fi
}

install_deps
install_zsh
install_nvim
install_npm
install_rust

echo "yay done"
echo "things to do after:"
echo "   nvm install node"
echo "   nvm use node"
echo "   sudo chsh -s /bin/zsh"
echo "   ./scripts/oh_my_zsh.sh"
