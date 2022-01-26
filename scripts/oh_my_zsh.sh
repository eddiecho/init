#/bin/bash

set -xe

CURR_DIR=~/init
FILE_NAME=$CURR_DIR/tmp/omzsh.sh

curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
  --output $FILE_NAME
chmod +x $FILE_NAME
sh $FILE_NAME
