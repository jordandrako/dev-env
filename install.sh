#!/bin/bash

initial="$PWD"
config=$initial/dotfiles
if [[ $1 ]]; then
  script_user=$1
else
  script_user=$USER
fi

# Echo with color
fancy_echo() {
  echo -e "\n\e[1;30;42m $1 \e[0m\n"
}

# Error echo
error() {
  echo -e "\n\e[1;5;30;41m $1 \e[0m\n" 1>&2 && echo -ne '\007' && exit 1
}

# Perform task successfully or print failed
successfully() {
  $* || ( error "FAILED" )
}

# Check system
case "$(uname -a)" in
  *Microsoft* )
    fancy_echo "Configuring WSL";
    ssh_path="/mnt/c/Users/$script_user/.ssh";
    machine="WSL" ;;
  CYGWIN* )
    fancy_echo "Configuring Cygwin";
    ssh_path="/cygdrive/c/Users/$script_user/.ssh";
    machine="Cygwin" ;;
  Linux* )
    fancy_echo "Configuring Linux";
    machine="Linux" ;;
  # Darwin* ) SUPPORT MAC LATER
  #   machine="Mac" ;;
  * )
    error "System Not Supported. Install manually."; exit 1
esac

# Check for oh-my-zsh
ZSH=$ZSH || ~/.oh-my-zsh
if [[ ! -d $ZSH ]]; then
  successfully wget https://githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O ~/install.oh-my-zsh.sh
  successfully chmod +x ~/install.oh-my-zsh.sh
  error "Ensure zsh is installed and run oh-my-zsh installer first @ '. ~/install.oh-my-zsh.sh'"
  exit 1
elif [[ ! -d $ZSH/custom/plugins/zsh-syntax-highlighting ]]; then
  successfully git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
  successfully chmod -R 755 $ZSH/custom/plugins/zsh-syntax-highlighting
fi


# Check for NVM
if [[ $machine != "Cygwin" && ! -d ~/.nvm ]]; then
  while true; do
    read -p "No NVM detected. Continue anyway? [Y/n] " nvmYn
    case $nvmYn in
      [Nn]* )
        successfully wget https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh -O ~/install.nvm.sh
        successfully chmod +x ~/install.nvm.sh
        error "Run NVM installer first '. ~/install.nvm.sh'"
        exit 1
        break;;
      * )
        npm_i=false;
        break;;
    esac
  done
else
  npm_i=true
fi

# Global configuration
successfully cp -b $config/.aliases.sh ~/
successfully cp -b $config/.zshrc ~/
successfully cp -b $config/.nanorc ~/.nano
# Cobalt2 theme
successfully mkdir -p $ZSH/custom/themes
successfully cp $config/cobalt2.zsh-theme $ZSH/custom/themes
successfully chmod -R 755 $ZSH/custom/themes
## Z plugin
if [[ ! -a ~/.bin/z.sh ]]; then
  mkdir -p ~/.bin
  wget -q https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/.bin/z.sh
  chmod +x ~/.bin/z.sh
fi

# Configure Git
fancy_echo "Configuring git"
while true; do
  read -p "Copy this gitconfig? [Y/n] " gitCpYn
  case $gitCpYn in
    [Nn]* ) break;;
    * )
      successfully cp -b $config/.gitconfig ~/
      break;;
  esac
done
while true; do
  read -p "Configure your git user settings? [Y/n] " gitUserYn
  case $gitUserYn in
    [Nn]* ) break;;
    * )
      fancy_echo "What's your first name?";
      read first_name;
      fancy_echo "What's your last name?";
      read last_name;
      gitname="$first_name $last_name";
      git config --global user.name "$gitname";
      echo ;
      fancy_echo "What's your git account email?";
      read email;
      git config --global user.email "$email";
      break;;
  esac
done

# Install NPM packages. Change these packages to your preferred global packages.
packages="yarn gulp-cli create-react-app trash-cli eslint tslint stylelint typescript ngrok"
if [[ $npm_i == true ]]; then
  fancy_echo "Installing global npm packages"
  while true; do
    read -p "Install global npm packages? [Y/n] " npmYn
    case $npmYn in
      [Nn]* ) break;;
      * )
        successfully npm i -g $packages;
        break;;
    esac
  done
fi

# Copy Windows user SSH
if [[ $machine == "WSL" || $machine == "Cygwin" ]]; then
  fancy_echo "Copy Windows user SSH"
  successfully chmod +x $initial/copy-ssh.sh
  fancy_echo "[Windows ONLY] Do you want your local windows user ssh keys in bash?"
  echo -ne '\007'
  while true; do
    read -p "Copy your windows ssh key? [Y/n] " sshYn
    case $sshYn in
      [Nn]* )
        echo "OK, you can do this later by running the copy-ssh.sh script.";
        break;;
      * )
        . $initial/copy-ssh.sh $ssh_path;
        break;;
    esac
  done
fi

# WSL Configuration
if [[ $machine == "WSL" ]]; then
  if ! command -v dos2unix >/dev/null 2>&1; then
    successfully sudo apt update
    successfully sudo apt install dos2unix
  fi
  # successfully sudo apt install dos2unix
  successfully cat $config/wsl.zshrc >> ~/.zshrc
  fancy_echo "Done!"
  exit
fi # End WSL

# Linux Configuration
if [[ $machine == "Linux" ]]; then
  successfully cat $config/linux.zshrc >> ~/.zshrc
  fancy_echo "Done!"
  exit
fi # End Linux

# Cygwin configuration
if [[ $machine == "Cygwin" ]]; then
  # Install apt-cyg to allow easy package installation
  if [[ ! -a /bin/apt-cyg ]]; then
    successfully wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg -P /bin/
    chmod +x /bin/apt-cyg
  fi

  successfully apt-cyg install chere gdb dos2unix openssh nano zip unzip bzip2 coreutils gawk grep sed diffutils patchutils tar bash-completion ca-certificates curl rsync

  successfully cp $config/.minttyrc ~/
  successfully cat $config/cygwin.zshrc >> ~/.zshrc
  fancy_echo "Done!"
  exit
fi # End Cygwin

fancy_echo "Done!"
