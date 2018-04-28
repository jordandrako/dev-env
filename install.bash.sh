#!/bin/bash

# Perform task successfully or print failed
successfully() {
	$* || ( echo -e "\n\e[1;5;41mFAILED\e[0m\n" 1>&2 && echo -ne '\007' && exit 1 )
}
# Echo with color
fancy_echo() {
	echo -e "\n\e[1;42m $1 \e[0m\n"
}

fancy_echo "Configuring ssh"
  if [[ -d ~/.ssh ]]; then
    successfully chown -R $USER:$GID ~/.ssh
    successfully chmod -R 700 ~/.ssh
    successfully chmod 644 ~/.ssh/id_rsa.pub
    successfully chmod 600 ~/.ssh/id_rsa
    successfully chmod 640 ~/.ssh/authorized_keys
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

if command -v npm >/dev/null 2>&1; then
fancy_echo "Installing global npm packages"
    successfully npm i -g npm yarn gulp-cli grunt-cli create-react-app trash-cli eslint tslint typescript ngrok
fi