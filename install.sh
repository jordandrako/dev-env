#!/bin/bash

initial="$PWD"
config=$initial/dotfiles
script_user=${1:-$USER}
npm_packages="yarn pnpm gulp-cli create-react-app trash-cli empty-trash-cli typescript eslint tslint ngrok"
NPM_ATTEMPTED=false

# Source common functions: green, info, error, try, ask.
source $config/.functions.sh

# Source the .zshrc file and exit.
success() {
  green "Done! Restart zsh or run source ~/.zshrc"
  exit 0
}

# Simplify installing packages between different systems.
install() {
  [[ ! $* ]] && error "You must pass packges to try to install."
  info "Installing '$*'"
  if [[ $CYGWIN == true ]]; then
    try apt-cyg install $*
  else
    try sudo apt-get update && try sudo apt-get install $* -y
  fi
}

# Ask if user wants to install global npm packages.
[[ -x $(command -v npm) ]] && npm_i=true || npm_i=false
ask_npm() {
  while $npm_i; do
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

# Install NPM packages. Installs from $npm_packages variable at the top of the file.
npm_install() {
  if [[ $npm_i ]]; then
    green "Installing global npm packages"
    try npm i -g $npm_packages || ( [[ $NPM_ATTEMPTED == false ]] && NPM_ATTEMPTED=true && info "Setting up global npm without sudo." && try npm_nosudo && try npm_install )
  else
    error "Couldn't find NPM, install packages manually."
  fi
}

# If global npm install fails, set up a workaround to store global packages in home directory.
npm_nosudo() {
  # Permanent configs
  [[ -a ~/.npmrc ]] && try cp ~/.npmrc ~/.npmrc.bak
  try npm config set prefix '~/.npm-global'
  [[ -a ~/.npm.nosudo.zsh ]] && try cp ~/.npm.nosudo.zsh ~/.npm.nosudo.zsh.bak
  try cp $config/.npm.nosudo.zsh ~/

  # Runtime config
  export PATH=~/.npm-global/bin:$PATH
}

# Ask to copy git config.
git_config() {
  while true; do
    ask "Copy this git config?" "y/N" gitCpYn
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

# Ask to run WLinux setup
ask_wlinux() {
  while true; do
    ask "Run wlinux-setup?" "y/N" wsYn
    case $wsYn in
      [yY]* )
        try run_wlinux_setup;
        break;;
      * ) break;;
    esac
  done
}

# Run wlinux-setup
run_wlinux_setup() {
  green "Running wlinux-setup"
  [[ -x /etc/setup ]] && /etc/setup
}

# Ask to set up WSL for GUI apps.
ask_xserver() {
  while true; do
    ask "Configure WSL for GUI applications?" "y/N" xYn
    case $xYn in
      [yY]* )
        try xserver_config;
        try ask_desktop;
        try ask_fonts;
        break;;
      * ) break;;
    esac
  done
}

# Install packages for GUI apps.
xserver_config() {
  green "Configuring XServer"
  [[ -a ~/.xsrv.zsh ]] && try cp ~/.xsrv.zsh ~/.xsrv.zsh.bak
  try cp $config/.xsrv.zsh ~/
  # Don't use install function, as user input is required.
  try sudo apt-get update && try sudo apt-get install -y xfce4 xfce4-terminal tilix xfce4-whiskermenu-plugin adapta-gtk-theme papirus-icon-theme firefox-esr
  # Remove screensavers
  info "Removing screensavers and other xfce programs that cause issues with WSL"
  try sudo apt-get -y purge xfce4-power-manager xscreensaver gnome-screensaver light-locker i3lock
}

ask_desktop() {
  while true; do
    ask "Copy xfce desktop configs?" "y/N" desktopYn
    case $desktopYn in
      [yY]* )
        try desktop_config;
        break;;
      * ) break;;
    esac
  done
}

desktop_config() {
  green "Configuring xfce desktop"
  if [[ -d ~/.config/xfce4 ]]; then
    [[ -d ~/.config/xfce4.bak ]] && try rm -rf ~/.config/xfce4.bak
    try mv ~/.config/xfce4 ~/.config/xfce4.bak
  fi
  if [[ -d ~/.config/Thunar ]]; then
    [[ -d ~/.config/Thunar.bak ]] && try rm -rf ~/.config/Thunar.bak
    try mv ~/.config/Thunar ~/.config/Thunar.bak
  fi
  try cp -R $config/xfce4-desktop/* ~/.config/
}

# Ask to share windows fonts with WSL.
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

# Copy local.conf to wsl to share windows fonts.
share_fonts() {
  green "Configuring Windows Fonts."
  [[ -a /etc/fonts/local.conf ]] && try sudo cp /etc/fonts/local.conf /etc/fonts/local.conf.bak
  try sudo cp $config/local.conf /etc/fonts/
}

# Ask to copy window user's SSH config to new workspace.
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
    try apt-cyg install git ;;
  Linux* )
    green "Now Configuring Linux";
    LINUX=true;;
  # Darwin* ) @TODO: SUPPORT MAC LATER
  #   machine="Mac" ;;
  * )
    error "System Not Supported. Install manually.";
    exit 1;;
esac

# Check for antibody
if [[ ! -x "$(command -v antibody)" ]]; then
  try curl -sL git.io/antibody | sh -s
fi

# Global configuration
[[ -a ~/.zshrc ]] && try cp ~/.zshrc ~/.zshrc.bak
try cp $config/.zshrc ~/

[[ -a ~/.key-bindings.zsh ]] && try cp ~/.key-bindings.zsh ~/.key-bindings.zsh.bak
try cp $config/.key-bindings.zsh ~/

[[ -a ~/.functions.sh ]] && try cp ~/.functions.sh ~/.functions.sh.bak
try cp $config/.functions.sh ~/

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

  [[ ! -x `command -v lsb_release` ]] && try install lsb-release
  [[ `lsb_release -sd` == "WLinux" ]] && try ask_wlinux

  ask_xserver
  git_config
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
  try apt-cyg remove git

  copy_ssh
  success
fi # End Cygwin

echo -ne '\007'
success
