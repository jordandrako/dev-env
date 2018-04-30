#!/bin/bash

initial="$PWD"

# Perform task successfully or print failed
successfully() {
  $* || ( echo -e "\n\e[1;5;30;41m FAILED \e[0m\n" 1>&2 && echo -ne '\007' && exit 1 )
}

# Echo with color
fancy_echo() {
  echo -e "\n\e[1;30;42m $1 \e[0m\n"
}

# Check system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine="Linux";;
    Darwin*)    machine="Mac";;
    CYGWIN*)    machine="Cygwin";;
    MINGW*)     machine="MinGw";;
    *)          machine="UNKNOWN:${unameOut}"
esac

# Configure oh-my-zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
  fancy_echo "Run oh-my-zsh installer first 'https://github.com/robbyrussell/oh-my-zsh'"
  exit 1
  else
  cp -r $initial/home/* ~/
fi

# Configure Cygwin
if [[ $machine == "Cygwin" ]]; then
fancy_echo "Configuring cygwin"
  if [[ ! -a /bin/apt-cyg ]]; then
    successfully wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg -P /bin/
    chmod +x /bin/apt-cyg
  fi
  successfully apt-cyg install zsh git gdb dos2unix openssh nano zip unzip bzip2 coreutils gawk grep sed diffutils patchutils tar bash-completion ca-certificates curl rsync
fi

# Configure SSH
fancy_echo "Configuring ssh"
if [[ -d ~/.ssh ]]; then
  successfully chown -R $USER:$GID ~/.ssh
  successfully chmod -R 700 ~/.ssh
  successfully chmod 644 ~/.ssh/id_rsa.pub
  successfully chmod 600 ~/.ssh/id_rsa
  if [[ -a ~/.ssh/authorized_keys ]]; then
    successfully chmod 640 ~/.ssh/authorized_keys
  fi
fi

# Configure Git
fancy_echo "Configuring git"
# Ask for Git config details
fancy_echo "What's your first and last name (for git)?"
read gitname1 gitname2
gitname="$gitname1 $gitname2"
fancy_echo "What's your email (for git)?"
read gitemail
git config --global user.name "$gitname"
git config --global user.email "$gitemail"

# Install NPM packages
if command -v npm >/dev/null 2>&1; then
  fancy_echo "Installing global npm packages"
    successfully npm i -g npm yarn gulp-cli grunt-cli create-react-app trash-cli eslint tslint typescript ngrok
fi
