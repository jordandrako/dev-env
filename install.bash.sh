#!/bin/bash

# Perform task successfully or print failed
successfully() {
	$* || ( echo -e "\n\e[1;5;41mFAILED\e[0m\n" 1>&2 && echo -ne '\007' && exit 1 )
}
# Echo with color
fancy_echo() {
	echo -e "\n\e[1;42m$1\e[0m\n"
}

fancy_echo "Configuring ssh"
  if [[ -d ~/.ssh ]]; then
    chown -R $USER:$GID ~/.ssh
    chmod -R 600 ~/.ssh
  fi

fancy_echo "Configuring git"
  # Ask for Git config details
  fancy_echo "What's your first and last name (for git)?"
  read gitname1 gitname2
  gitname="$gitname1 $gitname2"
  fancy_echo "What's your email (for git)?"
  read gitemail
  git config --global user.name "$gitname"
  git config --global user.email "$gitemail"