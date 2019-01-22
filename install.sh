#!/bin/bash

initial="$PWD"
config=$initial/dotfiles
script_user=${1:-$USER}
npm_packages="yarn pnpm gulp-cli create-react-app trash-cli empty-trash-cli typescript ngrok"
NPM_ATTEMPTED=false

# Green background echo
green() {
  echo -e "\n\e[1;32m$1\e[0m\n"
}

# Yellow background echo
info() {
  echo -e "\n\e[1;33m$1\e[0m\n"
}

# Error echo
error() {
  echo -e "\n\e[1;5;31m$1\e[0m\n" 1>&2 && echo -ne '\007' && exit 1
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
  echo -e "\n\e[1;34m$question\e[0m" && echo "[$options] > "
  [[ $3 ]] && read $3
}

# Source the .zshrc file and exit.
success() {
  green "Done! Restart zsh or run source ~/.zshrc"
  exit 0
}

npm_nosudo() {
  # Permanent configs
  [[ -a ~/.npmrc ]] && try cp ~/.npmrc ~/.npmrc.bak
  try npm config set prefix '~/.npm-global'
  [[ -a ~/.npm.nosudo.zsh ]] && try cp ~/.npm.nosudo.zsh ~/.npm.nosudo.zsh.bak
  try cp $config/.npm.nosudo.zsh ~/

  # Runtime config
  export PATH=~/.npm-global/bin:$PATH
}

# Install NPM packages. Installs from $npm_packages variable at the top of the file.
npm_install() {
  if [[ -x $(command -v npm) ]]; then
    green "Installing global npm packages"
    try npm i -g $npm_packages || ( [[ $NPM_ATTEMPTED == false ]] && NPM_ATTEMPTED=true && info "Setting up global npm without sudo." && try npm_nosudo && try npm_install )
  else
    error "Couldn't find NPM, install packages manually."
  fi
}

ask_npm() {
  while true; do
    info "$npm_packages"
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

share_fonts() {
  green "Configuring Windows Fonts."
  [[ -a /etc/fonts/local.conf ]] && try sudo cp /etc/fonts/local.conf /etc/fonts/local.conf.bak
  try sudo cp $config/local.conf /etc/fonts/
}

ask_fonts() {
  while true; do
    echo $npm_package
    ask "Share Windows fonts for GUI applications?" "y/N" fontsYn
    case $fontsYn in
      [yY]* )
        try share_fonts;
        break;;
      * ) break;;
    esac
  done
}

xserver_config() {
  green "Configuring XServer"
  [[ -a ~/.xsrv.zsh ]] && try cp ~/.xsrv.zsh ~/.xsrv.zsh.bak
  try cp $config/.xsrv.zsh ~/
  # Don't use install function, as user input is required.
  try sudo apt-get update && try sudo apt-get install -y xfce4 xfce4-terminal xfce4-whiskermenu-plugin arc-theme papirus-icon-theme firefox-esr
  # Remove screensavers
  info "Removing screensavers"
  try sudo apt-get -y purge xscreensaver gnome-screensaver light-locker i3lock >> /dev/null
}

ask_xserver() {
  while true; do
    ask "Configure XServer for GUI applications?" "y/N" xYn
    case $xYn in
      [yY]* )
        try xserver_config;
        try ask_fonts;
        break;;
      * ) break;;
    esac
  done
}

# Check system
case "$(uname -a)" in
  *Microsoft* )
    green "Now Configuring WSL";
    [[ -d /c ]] && ssh_path="/c/Users/$script_user/.ssh" || ssh_path="/mnt/c/Users/$script_user/.ssh";
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
    try sudo apt-get update > /dev/null && try sudo apt-get install $* -y > /dev/null
  fi
}

# Copy Windows user SSH
copy_ssh() {
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

# Check for antibody
if [[ ! -x "$(command -v antibody)" ]]; then
  try curl -sL git.io/antibody | sh -s
fi

# Global configuration
[[ -a ~/.zshrc ]] && try cp ~/.zshrc ~/.zshrc.bak
try cp $config/.zshrc ~/

[[ -a ~/.key-bindings.zsh ]] && try cp ~/.key-bindings.zsh ~/.key-bindings.zsh.bak
try cp $config/.key-bindings.zsh ~/

[[ -a ~/.aliases.sh ]] && try cp ~/.aliases.sh ~/.aliases.sh.bak
try cp $config/.aliases.sh ~/

[[ -a ~/.nanorc ]] && try cp ~/.nanorc ~/.nanorc.bak
try cp $config/.nanorc ~/

# fzf plugin
if [[ ! -f ~/.fzf.zsh ]]; then
  [[ -d ~/.fzf ]] && try rm -rf ~/.fzf
  try git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  try ~/.fzf/install --no-bash --no-fish --no-update-rc --key-bindings --completion
fi

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
