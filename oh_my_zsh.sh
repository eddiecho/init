#/bin/bash

set -xe

apt update
apt install zsh -y

# this file can't be run in a script?
# also cannot be run as sudo
# also can't pipe in yes, since it asks for password
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# change ZSH_THEME="af-magic"

