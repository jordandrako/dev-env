#!/bin/bash

# If you want your local machine id_rsa key to be used by bash
echo "Do you want your local user (windows) id_rsa ssh keys in bash?"
echo -ne '\007'
while true; do
    read -p "Copy your windows ssh key? [y/N]" yn
    case $yn in
        [Yy]* ) cp -r "/cygdrive/c/Users/$USERNAME/.ssh" ~; break;;
        [Nn]* ) break;;
        * ) break;;
    esac
done

if [[ -a "/cygdrive/c/Users/$USERNAME/code/dev-env/install.sh" ]]; then
  cd /cygdrive/c/Users/$USERNAME/code/dev-env
  . install.sh
fi