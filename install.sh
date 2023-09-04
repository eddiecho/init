# install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# install home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
# this should also install the home-manager config and set everything up
nix-shell '<home-manager>' -A install

# setup zsh
which zsh | sudo tee -A /etc/shells
chsh -s $(which zsh)

# install neovim
git clone --depth 1 git@github.com:neovim/neovim
pushd neovim
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=/usr/local
sudo make install
popd
