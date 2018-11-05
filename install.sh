#!/bin/bash

initial="$PWD"
initial_path="$PATH"
config=$initial/dotfiles
script_user=${1:-$USER}

# Green background echo
green() {
  echo -e "\n\e[1;30;42m $1 \e[0m\n"
}

# Yellow background echo
info() {
  echo -e "\n\e[1;30;43m $1 \e[0m\n"
}

# Error echo
error() {
  echo -e "\n\e[1;5;30;41m $1 \e[0m\n" 1>&2 && echo -ne '\007' && exit 1
}

# Perform task successfully or print failed
try() {
  ( $* && success=true ) || ( success=false && error "FAILED: $*" )
}

# Ask with blue background.
# Pass question and options: `ask "question" "yes/no" readVarName`
ask() {
  [[ ! $1 ]] && error "You must pass a question to ask!"
  question=$1
  options=${2:-"y/n"}
  echo -e "\n\e[1;30;44m $question \e[0m" && echo "[$options] > "
  [[ $3 ]] && read $3
}

# Check if npm is installed
check_npm() {
  if [[ -x $(command -v npm) ]]; then
    npm_i=true
  else
    npm_i=false
  fi
}

# Check system
case "$(uname -a)" in
  *Microsoft* )
    green "Now Configuring WSL";
    ssh_path="/mnt/c/Users/$script_user/.ssh";
    machine="WSL" ;;
  CYGWIN* )
    green "Now Configuring Cygwin";
    ssh_path="/cygdrive/c/Users/$script_user/.ssh";
    machine="Cygwin" ;
    echo "WORKAROUND: Temporarily installing Cygwin's git.";
    apt-cyg install git;;
  Linux* )
    green "Now Configuring Linux";
    machine="Linux" ;;
  # Darwin* ) TODO: SUPPORT MAC LATER
  #   machine="Mac" ;;
  * )
    error "System Not Supported. Install manually.";
    exit 1;;
esac

# Install fish functions
install_fish() {
  green "Installing fish"
  if [[ $machine == "WSL" || $machine == "Linux" ]]; then
    try sudo apt update && try sudo apt install fish -y || \
    try sudo apt-add-repository -yu ppa:fish-shell/release-2 > /dev/null 2>&1 && \
    try sudo apt install fish -y && \
    try chmod +x $initial/fish-config.fish && \
    info "Fish is now installed. Run fish-config.fish for more fish config."
  elif [[ $machine == "Cygwin" ]]; then
    try apt-cyg install fish
  fi
}

ask_fish() {
  if [[ ! -x "$(command -v fish)" ]]; then
    while true; do
      ask "Do you want to install fish?" "y/n" fishYn
      case $fishYn in
        [Yy]* )
          install_fish;
          break;;
        * ) break;;
      esac
    done
  fi
}

# Check for oh-my-zsh
ZSH=${ZSH:-~/.oh-my-zsh}
if [[ ! -d $ZSH ]]; then
  try wget -q https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O ~/install.oh-my-zsh.sh
  try chmod +x ~/install.oh-my-zsh.sh
  error "Ensure zsh is installed and run oh-my-zsh installer first @ '. ~/install.oh-my-zsh.sh'"
  exit 1
else
  # zsh-syntax-highlighting plugin
  if [[ ! -d $ZSH/custom/plugins/zsh-syntax-highlighting ]]; then
    try git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
  fi

  # zsh-nvm plugin
  if [[ ! -d $ZSH/custom/plugins/zsh-nvm ]]; then
    try git clone -q https://github.com/lukechilds/zsh-nvm $ZSH/custom/plugins/zsh-nvm
  fi
fi
try chmod -R 755 $ZSH/custom/plugins/zsh-syntax-highlighting $ZSH/custom/plugins/zsh-nvm

# Check for N
if [[ $machine != "Cygwin" && ! -d $N_PREFIX ]]; then
  while true; do
    try cp $config/install.n.sh ~/
    try wget -q https://git.io/n-install -O ~/tmp.n.sh
    try cat ~/tmp.n.sh >> ~/install.n.sh
    try chmod +x ~/install.n.sh
    ask "N not detected. Continue anyway?" "Y/n" nYn
    case $nYn in
      [Nn]* )
        error "Run N installer '~/install.n.sh'";
        break;;
      * )
        info "You can install N later by running '~/install.n.sh'";
        break;;
    esac
  done
fi

# Global configuration
[[ -a ~/.aliases.sh ]] && try cp ~/.aliases.sh ~/.aliases.sh.bak
try cp $config/.aliases.sh ~/

[[ -a ~/.zshrc ]] && try cp ~/.zshrc ~/.zshrc.bak
try cp $config/.zshrc ~/

[[ -a ~/.nanorc ]] && try cp ~/.nanorc ~/.nanorc.bak
try cp $config/.nanorc ~/

# fzf plugin
if [[ ! -f ~/.fzf.zsh ]]; then
  [[ -d ~/.fzf ]] && try rm -rf ~/.fzf
  try git clone -q --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  try ~/.fzf/install --no-bash --no-fish --no-update-rc --key-bindings --completion
fi

# Cobalt2 theme
[[ -d $ZSH && ! -d $ZSH/custom/themes ]] && mkdir -p $ZSH/custom/themes
try cp $config/cobalt2custom.zsh-theme $ZSH/custom/themes/
try chmod 755 $ZSH/custom/themes/cobalt2custom.zsh-theme

# Configure Git
while true; do
  ask "Copy this gitconfig?" "Y/n" gitCpYn
  case $gitCpYn in
    [Nn]* ) break;;
    * )
      if [[ -a ~/.gitconfig ]];
        then mv ~/.gitconfig ~/.gitconfig.bak;
      fi;
      try cp $config/.gitconfig ~/;
      break;;
  esac
done
while true; do
  ask "Configure your git user settings?" "Y/n" gitUserYn
  case $gitUserYn in
    [Nn]* ) break;;
    * )
      ask "What's your first name?" "First Name" first_name;
      ask "What's your last name?" "Last Name" last_name;
      gitname="$first_name $last_name";
      git config --global user.name "$gitname";
      echo ;
      ask "What's your git account email?" "email" email;
      git config --global user.email "$email";
      break;;
  esac
done

# Install NPM packages. Change these packages to your preferred global packages.
packages="yarn gulp-cli create-react-app trash-cli empty-trash-cli typescript ngrok"
check_npm
if [[ $npm_i == true ]]; then
  while true; do
    ask  "Install global npm packages?" "Y/n" npmYn
    case $npmYn in
      [Nn]* ) break;;
      * )
        green "Installing global npm packages";
        try npm i -g $packages;
        break;;
    esac
  done
fi

# Copy Windows user SSH
if [[ $machine == "WSL" || $machine == "Cygwin" ]]; then
  green "[Windows ONLY] Copy user SSH"
  try chmod +x $initial/copy-ssh.sh
  while true; do
    ask "Copy your windows ssh key?" "y/N" sshYn
    case $sshYn in
      [Yy]* )
        try . $initial/copy-ssh.sh $ssh_path;
        break;;
      * )
        info "You can copy ssh later by running '. path/to/dev-env/copy-ssh.sh path/to/.ssh'"
        break;;
    esac
  done
fi

# WSL Configuration
if [[ $machine == "WSL" ]]; then
  if ! command -v dos2unix >/dev/null 2>&1; then
    try sudo apt update
    try sudo apt install dos2unix make
  fi
  # try sudo apt install dos2unix
  try cat $config/wsl.zshrc >> ~/.zshrc
  ask_fish
  green "Done!"
  exit 0
fi # End WSL

# Linux Configuration
if [[ $machine == "Linux" ]]; then
  try cat $config/linux.zshrc >> ~/.zshrc
  ask_fish
  green "Done!"
  exit 0
fi # End Linux

# Cygwin configuration
if [[ $machine == "Cygwin" ]]; then
  # Install apt-cyg to allow easy package installation
  if [[ ! -a /bin/apt-cyg ]]; then
    try wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg -P /bin/
    chmod +x /bin/apt-cyg
  fi

  try apt-cyg install chere gdb dos2unix openssh nano zip unzip bzip2 coreutils gawk grep sed diffutils patchutils tar bash-completion ca-certificates curl rsync

  # Remove cygwin's version of git since it's well supported.
  try apt-cyg remove git

  try cp $config/.minttyrc ~/
  try cat $config/cygwin.zshrc >> ~/.zshrc
  ask_fish
  green "Done!"
  exit 0
fi # End Cygwin

echo -ne '\007'
green "Done!"
