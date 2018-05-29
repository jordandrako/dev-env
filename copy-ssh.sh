#!/bin/bash

# Args/variables
machine=$1
user=$2 || $USER
s=~/.ssh

# Fail if no machine argument passed
if [[ $machine ]]; then
  if [[ $machine == "Cygwin" || $machine == "cygwin" ]]; then
    dos_ssh=/cygdrive/c/Users/$user/.ssh
  elif [[ $machine == "WSL" || $machine == "wsl" ]]; then
    dos_ssh=/mnt/c/Users/$user/.ssh
  fi
else
  echo -e "\nYou need to specify your install type (Cygwin | WSL)\n"
  exit 1
fi

# Fail if current user already has .ssh directory configured to prevent
# overriding users current configs on accident.
if [[ -d $s ]]; then
  echo -e "\nSSH directory already exists, delete first then try again.\n"
  exit 1
fi

# Copy SSH directory
cp -r $dos_ssh ~
dos2unix -q $s/*

# Configure SSH permissions
if [[ -d $s ]]; then
  chown -R $USER:$GID $s
  chmod -R 700 $s
  chmod 644 $s/id_rsa.pub
  chmod 600 $s/id_rsa
  if [[ -a $s/authorized_keys ]]; then
    chmod 640 $s/authorized_keys
  fi
fi

echo -e "\nDone copying SSH.\n"
