#!/bin/bash

set -xe

# this shit is such a mess
# TERRIBLE THINGS CAN HAPPEN IF THIS IS RUN MULTIPLE TIMES!!!
# PYTHON IS FUCKING TRASH

sudo apt update
sudo apt install software-properties-common

sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt install python3.8

sudo update-alternatives --remove-all python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 10000
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.8 10000

# do i need this????
# could throw an error about apt_pkg not found for python3.8 
# because of course it does
sudo apt install python3-apt
sudo apt install python3-distutils

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

# because installing pip doesnt add it to path hurrdurr
export PATH=$PATH:/home/eddie/.local/bin
