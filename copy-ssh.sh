#!/bin/bash
# Run this script with the path to your windows .ssh folder.
# Optionally, specify your ssh key name after the path.

dos_ssh=$1
s=~/.ssh
key_name=${2:-'id_rsa'}

# Fail if no machine argument passed
if [[ ! -d $dos_ssh ]]; then
  echo -e "\nYou need to specify your .ssh directory path when running this script.\nUsually something like: \"./copy-ssh.sh '/<mnt | cygdrive>/c/Users/<USERNAME>/.ssh'\")\n"
  exit 1
elif [[ ! -a "$dos_ssh/$key_name" ]]; then
  echo -e "\nThat doesn't seem to be the correct directory. It should contain a key named '$key_name'.\n"

  while true; do
    read -p "Would you like specify an alternate key name? [y/n] " yn
    case $yn in
      [Nn]* )
        echo -e "\nExiting.\n";
        exit 1;;
      [Yy]* )
        echo -e "\n";
        read -p "Enter your key name: " key_name;
        break;;
    esac
  done
fi

if [[ ! -a $dos_ssh/$key_name ]]; then
  echo "Can't find the key '$key_name'. Try again."
  exit 1
fi

# Fail if current user already has .ssh directory configured to prevent
# overriding users current configs on accident.
if [[ -d $s ]]; then
  echo -e "\nSSH directory already exists, delete first then try running copy-ssh.sh again.\n"
  exit 1
fi

# Copy SSH directory
cp -r $dos_ssh ~
dos2unix -q $s/*

# Configure SSH permissions
if [[ -d $s ]]; then
  chown -R $USER:$GID $s
  chmod -R 700 $s
  chmod 644 $s/$key_name.pub
  chmod 600 $s/$key_name
  if [[ -a $s/authorized_keys ]]; then
    chmod 640 $s/authorized_keys
  fi
fi

echo -e "\nDone copying SSH.\n"
