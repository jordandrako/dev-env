#!/bin/bash

initial="$PWD"
config=$initial/dotfiles
script_user=${1:-$USER}
npm_packages="yarn gulp-cli create-react-app trash-cli empty-trash-cli typescript ngrok"

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

# Source the .zshrc file and exit.
success() {
  green "Done! Restart zsh or run source ~/.zshrc"
  exit 0
}

# Install NPM packages. Installs from $npm_packages variable at the top of the file.
npm_install() {
  if [[ -x $(command -v npm) ]]; then
    green "Installing global npm packages"
    try npm i -g $npm_packages || ( info "Retrying with sudo" && try sudo npm i -g $npm_packages )
  else
    error "Couldn't find NPM, install packages manually."
  fi
}

ask_npm() {
  while true; do
    info $npm_packages
    ask "Install the above global npm packages?" "y/N" npmYn
    case $npmYn in
      [yY]* )
        try npm_install;
        break;;
      * ) break;;
    esac
  done
}

# Configure Git
git_global() {
  while true; do
    ask "Configure your git user settings?" "y/N" gitUserYn
    case $gitUserYn in
      [Nn]* ) break;;
      * )
        ask "What's your first name?" "First Name" first_name;
        ask "What's your last name?" "Last Name" last_name;
        gitname="$first_name $last_name";
        try git config --global user.name "$gitname";
        echo ;
        ask "What's your git account email?" "email" email;
        try git config --global user.email "$email";
        break;;
    esac
  done
}

git_config() {
  while true; do
    ask "Copy this gitconfig?" "y/N" gitCpYn
    case $gitCpYn in
      [Yy]* )
        if [[ -a ~/.gitconfig ]];
          then mv ~/.gitconfig ~/.gitconfig.bak;
        fi;
        try cp $config/.gitconfig ~/;
        git_global;
        break;;
      * ) break;;
    esac
  done
}

# Check system
case "$(uname -a)" in
  *Microsoft* )
    green "Now Configuring WSL";
    ssh_path="/mnt/c/Users/$script_user/.ssh";
    WSL=true;;
  CYGWIN* )
    green "Now Configuring Cygwin";
    ssh_path="/cygdrive/c/Users/$script_user/.ssh";
    CYGWIN=true
    info "WORKAROUND: Temporarily installing Cygwin's git."
    try apt-cyg install git > /dev/null 2>&1 ;;
  Linux* )
    green "Now Configuring Linux";
    LINUX=true;;
  # Darwin* ) @TODO: SUPPORT MAC LATER
  #   machine="Mac" ;;
  * )
    error "System Not Supported. Install manually.";
    exit 1;;
esac

# Simplify installing packages between different systems.
install() {
  [[ ! $* ]] && error "You must pass packges to try to install."
  if [[ $CYGWIN == true ]]; then
    try apt-cyg install $* > /dev/null
  else
    try sudo apt-get -qq update > /dev/null && try sudo apt-get -qq install $* -y > /dev/null
  fi
}

# Copy Windows user SSH
copy_ssh() {
  green "[Windows ONLY] Copy user SSH"

  if [[ ! $CYGWIN == true && ! -x $(command -v dos2unix) ]]; then
    try install dos2unix make
  fi

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
}

# Install fish functions
install_fish() {
  green "Installing fish"
  if [[ $CYGWIN == true ]]; then
    try install fish
  else
    try install fish || \
    try sudo apt-add-repository -yu ppa:fish-shell/release-2 > /dev/null 2>&1 && \
    try install fish && \
    try chmod +x $initial/fish-config.fish && \
    info "Fish is now installed. Run fish-config.fish for more fish config."
  fi
}

ask_fish() {
  if [[ ! -x "$(command -v fish)" ]]; then
    while true; do
      ask "Do you want to install fish?" "y/n" fishYn
      case $fishYn in
        [Yy]* )
          try install_fish;
          break;;
        * ) break;;
      esac
    done
  fi
}

xserver_config() {
  green "Configuring XServer: dbus and environment variables."
  [[ -a /etc/sudoers.d/dbus ]] && try sudo cp /etc/sudoers.d/dbus ~/sudoers.dbus.bak
  try sudo rm /etc/sudoers.d/dbus && echo "$USER ALL = (root) NOPASSWD: /etc/init.d/dbus" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/dbus
  [[ -a ~/.xsrv.zsh ]] && try cp ~/.xsrv.zsh ~/.xsrv.zsh.bak
  try cp $config/.xsrv.zsh ~/.xsrv.zsh
}

ask_xserver() {
  while true; do
    echo $npm_package
    ask "Configure XServer for GUI applications?" "y/N" xYn
    case $xYn in
      [yY]* )
        try xserver_config;
        break;;
      * ) break;;
    esac
  done
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

# Global configuration
[[ -a ~/.zshrc ]] && try cp ~/.zshrc ~/.zshrc.bak
try cp $config/.zshrc ~/

[[ -a ~/.aliases.sh ]] && try cp ~/.aliases.sh ~/.aliases.sh.bak
try cp $config/.aliases.sh ~/

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

# WSL Configuration
if [[ $WSL == true ]]; then
  [[ -a ~/.wsl.zsh ]] && try cp ~/.wsl.zsh ~/.wsl.zsh.bak
  try cp $config/.wsl.zsh ~/

  try install lsb-release

  git_config
  ask_xserver
  ask_npm
  copy_ssh
  success
fi # End WSL

# Linux Configuration
if [[ $LINUX == true ]]; then
  [[ -a ~/.linux.zsh ]] && try cp ~/.linux.zsh ~/.linux.zsh.bak
  try cp $config/.linux.zsh ~/

  try install lsb-release

  git_config
  ask_npm
  success
fi # End Linux

# Cygwin configuration
if [[ $CYGWIN == true ]]; then
  [[ -a ~/.cygwin.zsh ]] && try cp ~/.cygwin.zsh ~/.cygwin.zsh.bak
  try cp $config/.cygwin.zsh ~/

  [[ -a ~/.minttyrc ]] && try cp ~/.minttyrc ~/.minttyrc.bak
  try cp $config/.minttyrc ~/

  # Install apt-cyg to allow easy package installation
  if [[ ! -a /bin/apt-cyg ]]; then
    try wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg -P /bin/
    chmod +x /bin/apt-cyg
  fi

  try install chere gdb dos2unix openssh nano zip unzip bzip2 coreutils gawk grep sed diffutils patchutils tar bash-completion ca-certificates curl rsync

  git_config
  ask_npm

  # Remove cygwin's version of git since it isn't well supported.
  info "Removing Cygwin's git."
  try apt-cyg remove git > /dev/null

  copy_ssh
  success
fi # End Cygwin

echo -ne '\007'
success
