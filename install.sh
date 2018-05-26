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
case "$(uname -a)" in
    Linux*Microsoft* )
      machine="Linux WSL" ;;
    Linux* )
      machine="Linux" ;;
    CYGWIN* )
      machine="Cygwin" ;;
    # Darwin* )
    #   machine="Mac" ;;
    * )
      echo "System not supported"; exit 1
esac

# Configure Cygwin
if [[ $machine == "Cygwin" ]]; then
fancy_echo "Configuring cygwin"
  if [[ ! -a /bin/apt-cyg ]]; then
    successfully wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg -P /bin/
    chmod +x /bin/apt-cyg
  fi
  successfully apt-cyg install zsh chere gdb dos2unix openssh nano zip unzip bzip2 coreutils gawk grep sed diffutils patchutils tar bash-completion ca-certificates curl rsync
elif [[ $machine =~ "Linux" ]]; then
  successfully sudo apt install zsh zip unzip
fi

# Check for NVM
if [[ ! -d ~/.nvm ]]; then
  wget https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -O ~/install.nvm.sh
    chmod +x ~/install.nvm.sh
  fancy_echo "Run NVM installer first '. ~/install.nvm.sh'"
  exit 1
fi

# Configure oh-my-zsh & home directory
if [[ ! -d ~/.oh-my-zsh ]]; then
  wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O ~/install.oh-my-zsh.sh
  chmod +x ~/install.oh-my-zsh.sh
  fancy_echo "Run oh-my-zsh installer first '. ~/install.oh-my-zsh.sh'"
  exit 1
else
  fancy_echo "Copying home directory configs"
  cp -a $initial/home/. ~/
fi

# Configure Git
fancy_echo "Configuring git"
# Ask for Git config details
echo -ne '\007'
while true; do
  read -p "Configure your git user settings? [Y/n]" gitYn
  case $gitYn in
    [Nn]* ) break;;
    * )
      fancy_echo "What's your first name?";
      read first_name;
      fancy_echo "What's your last name?";
      read last_name;
      gitname="$first_name $last_name";
      git config --global user.name "$gitname";
      fancy_echo "What's your git account email?";
      read email;
      git config --global user.email "$email";
      break;;
  esac
done

# Install NPM packages. Change these packages to your preferred global packages.
packages="yarn gulp-cli create-react-app trash-cli eslint tslint stylelint typescript ngrok"

fancy_echo "Installing global npm packages"
if command -v npm >/dev/null 2>&1; then
  while true; do
    read -p "Install global npm packages? [Y/n]" npmYn
    case $npmYn in
      [Nn]* ) break;;
      * )
        successfully npm i -g $packages;
        break;;
    esac
  done
else
  printf "No NPM. Run `nvm install --lts` then install these npm packages globally:\n$packages"
fi

# Configure SSH
fancy_echo "Configuring SSH"
successfully chmod +x $initial/copy-ssh.sh
fancy_echo "Do you want your local user (windows) ssh keys in bash?"
echo -ne '\007'
while true; do
  read -p "Copy your windows ssh key? [Y/n]" sshYn
  case $sshYn in
    [Nn]* ) break;;
    * )
      . $initial/copy-ssh.sh $machine;
      break;;
  esac
done

if [[ $machine =~ "Linux" ]]; then
  source ~/.zshrc
fi
