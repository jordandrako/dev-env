#!/bin/bash

# Check system
machine=$1

if [[ $machine ]]; then
  if [[ $machine == "Cygwin" ]]; then
    home_dir=/cygdrive/c/Users/$USER
  elif [[ $machine == "Linux" ]]; then
    home_dir=/mnt/c/Users/$USER
  fi
else
  echo "You need to specify your install type (Cygwin | Linux)"
  exit 1
fi

# Copy SSH directory
echo "Copying ssh"
cp -r "$home_dir/.ssh" ~

# Configure SSH permissions
echo "Configuring ssh permissions"
if [[ -d ~/.ssh ]]; then
  chown -R $USER:$GID ~/.ssh
  chmod -R 700 ~/.ssh
  chmod 644 ~/.ssh/id_rsa.pub
  chmod 600 ~/.ssh/id_rsa
  if [[ -a ~/.ssh/authorized_keys ]]; then
    chmod 640 ~/.ssh/authorized_keys
  fi
fi
