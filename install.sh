#!/bin/bash

initial="$PWD"
initial_path="$PATH"
config=$initial/dotfiles
script_user=${1:-$USER}

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
    fancy_echo "Now Configuring WSL";
    ssh_path="/mnt/c/Users/$script_user/.ssh";
    machine="WSL" ;;
  CYGWIN* )
    fancy_echo "Now Configuring Cygwin";
    ssh_path="/cygdrive/c/Users/$script_user/.ssh";
    machine="Cygwin" ;;
  Linux* )
    fancy_echo "Now Configuring Linux";
    machine="Linux" ;;
  # Darwin* ) SUPPORT MAC LATER
  #   machine="Mac" ;;
  * )
    error "System Not Supported. Install manually."; exit 1
esac

# Install fish functions
install_fish() {
  fancy_echo "Installing fish"
  if [[ $machine == "WSL" || $machine == "Linux" ]]; then
    successfully sudo apt-add-repository -yu ppa:fish-shell/release-2 > /dev/null 2>&1
    successfully sudo apt install fish
    successfully chmod +x $initial/fish-config.fish && \
    fancy_echo "Fish is now installed. Run fish-config.fish for more fish config."
  elif [[ $machine == "Cygwin" ]]; then
    successfully apt-cyg install fish
  fi
}
ask_fish() {
  [[ -x "$(command -v fish)" ]] && fish_i=true
  while true; do
    echo -e "\n "
    read -p "Do you want to install fish? [y/n] > " fishYn
    case $fishYn in
      [Yy]* )
        install_fish;
        break;;
      * ) break;;
    esac
  done
}

check_npm() {
  if [[ -x $(command -v npm) ]]; then
    npm_i=true
  else
    npm_i=false
  fi
}

# Check for oh-my-zsh
ZSH=$ZSH || ~/.oh-my-zsh
if [[ ! -d $ZSH ]]; then
  successfully wget -q https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O ~/install.oh-my-zsh.sh
  successfully chmod +x ~/install.oh-my-zsh.sh
  error "Ensure zsh is installed and run oh-my-zsh installer first @ '. ~/install.oh-my-zsh.sh'"
  exit 1
elif [[ ! -d $ZSH/custom/plugins/zsh-syntax-highlighting ]]; then
  successfully git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
fi
successfully chmod -R 755 $ZSH/custom/plugins/zsh-syntax-highlighting

# Check for N
if [[ $machine != "Cygwin" && ! -d $N_PREFIX ]]; then
  while true; do
    read -p "n not detected. Continue anyway? [Y/n] > " nYn
    case $nYn in
      [Nn]* )
        successfully cp $config/install.n.sh ~/
        successfully wget https://git.io/n-install -O ~/tmp.n.sh
        successfully cat ~/tmp.n.sh >> ~/install.n.sh
        successfully chmod +x ~/install.n.sh
        error "Run n installer first '. ~/install.n.sh'"
        exit 1
        break;;
      * )
        n_i=false;
        break;;
    esac
  done
fi

check_npm

# Global configuration
[[ -a ~/.aliases.sh ]] && successfully cp ~/.aliases.sh ~/.aliases.sh.bak
successfully cp $config/.aliases.sh ~/

[[ -a ~/.zshrc ]] && successfully cp ~/.zshrc ~/.zshrc.bak
successfully cp $config/.zshrc ~/

[[ -a ~/.nanorc ]] && successfully cp ~/.nanorc ~/.nanorc.bak
successfully cp $config/.nanorc ~/

# Cobalt2 theme
[[ -d $ZSH && ! -d $ZSH/custom/themes ]] && mkdir -p $ZSH/custom/themes
[[ ! -a $ZSH/custom/themes/cobalt2custom.zsh-theme ]] && successfully cp $config/cobalt2custom.zsh-theme $ZSH/custom/themes/
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
  read -p "Copy this gitconfig? [Y/n] > " gitCpYn

  case $gitCpYn in
    [Nn]* ) break;;
    * )
      if [[ -a ~/.gitconfig ]];
        then mv ~/.gitconfig ~/.gitconfig.bak;
      fi;
      successfully cp $config/.gitconfig ~/;
      break;;
  esac
done
while true; do
  read -p "Configure your git user settings? [Y/n] > " gitUserYn
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
packages="yarn gulp-cli create-react-app trash-cli empty-trash-cli eslint tslint stylelint typescript ngrok"
if [[ $npm_i == true ]]; then
  fancy_echo "Installing global npm packages"
  while true; do
    read -p "Install global npm packages? [Y/n] > " npmYn
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
    read -p "Copy your windows ssh key? [Y/n] > " sshYn
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
    successfully sudo apt install dos2unix make
  fi
  # successfully sudo apt install dos2unix
  successfully cat $config/wsl.zshrc >> ~/.zshrc
  ask_fish
  fancy_echo "Done!"
  exit
fi # End WSL

# Linux Configuration
if [[ $machine == "Linux" ]]; then
  successfully cat $config/linux.zshrc >> ~/.zshrc
  ask_fish
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

  successfully apt-cyg remove git

  successfully cp $config/.minttyrc ~/
  successfully cat $config/cygwin.zshrc >> ~/.zshrc
  ask_fish
  fancy_echo "Done!"
  exit
fi # End Cygwin

fancy_echo "Done!"
