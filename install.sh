#!/usr/bin/zsh

initial="$PWD"
config=$initial/dotfiles
script_user=${1:-$USER}
npm_packages="trash-cli empty-trash-cli typescript eslint ngrok"
NPM_ATTEMPTED=false
c=/mnt/c
[[ -d /c ]] && c=/c

# Source common functions: green, info, error, try, ask.
source $config/.functions.zsh

isInstalled zsh && green "zsh found, continuing..." || error "zsh not found. Install zsh first." 1

# Source the .zshrc file and exit.
success() {
  green "Done! Restarting zsh..."
  exec zsh
}

# Simplify installing packages between different systems.
install() {
  [[ ! $* ]] && error "You must pass packges to try to install."
  info "Installing '$*'"
  if [[ $MAC == true ]]; then
    try brew update && try brew install $*
  elif [[ $CYGWIN == true ]]; then
    try apt-cyg install $*
  else
    try sudo apt-get update && try sudo apt-get install $* -y
  fi
}

ask_dotfile_install() {
  while true; do
    ask "Install dev-env dotfiles? This will backup and override existing dotfiles." "Y/n" oYn
    case $oYn in
      [nN]* )
        break;;
      * )
        try dotfile_install;
        break;;
    esac
  done
}

dotfile_install() {
  # Global configuration
  [[ -d $c/cmder ]] && cp -rf $initial/cmder/* $c/cmder/

  [[ -a ~/.zshrc ]] && try cp ~/.zshrc ~/.zshrc.bak
  try cp $config/.zshrc ~/

  [[ -a ~/.p10k.zsh ]] && try cp ~/.p10k.zsh ~/.p10k.zsh.bak
  try cp $config/.p10k.zsh ~/

  [[ -a ~/.config/.key-bindings.zsh ]] && try cp ~/.config/.key-bindings.zsh ~/.config/.key-bindings.zsh.bak
  try cp $config/.key-bindings.zsh ~/.config/

  [[ -a ~/.config/.functions.zsh ]] && try cp ~/.config/.functions.zsh ~/.config/.functions.zsh.bak
  try cp $config/.functions.zsh ~/.config/

  [[ -a ~/.config/.aliases.zsh ]] && try cp ~/.config/.aliases.zsh ~/.config/.aliases.zsh.bak
  try cp $config/.aliases.zsh ~/.config/

  [[ -a ~/.nanorc ]] && try cp ~/.nanorc ~/.nanorc.bak
  try cp $config/.nanorc ~/

  [[ -a ~/.tmux.conf ]] && try cp ~/.tmux.conf ~/.tmux.conf.bak
  try cp $config/.tmux.conf ~/

  # fzf plugin
  if [[ ! -f ~/.fzf.zsh ]]; then
    [[ -d ~/.fzf ]] && try rm -rf ~/.fzf
    try git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    try ~/.fzf/install --no-bash --no-fish --no-update-rc --key-bindings --completion
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
  [[ -a ~/.config/.npm.nosudo.zsh ]] && try cp ~/.config/.npm.nosudo.zsh ~/.config/.npm.nosudo.zsh.bak
  try cp $config/.npm.nosudo.zsh ~/.config/

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

# Ask to run Pengwin setup
ask_pengwin() {
  while [[ -x `command -v pengwin-setup` ]]; do
    ask "Run pengwin-setup?" "y/N" psYn
    case $psYn in
      [yY]* )
        try run_pengwin_setup;
        break;;
      * ) break;;
    esac
  done
}

# Run pengwin-setup
run_pengwin_setup() {
  green "Running pengwin-setup"
  [[ -x `command -v pengwin-setup` ]] && try pengwin-setup
}

# Ask to copy window user's SSH config to new workspace.
copy_ssh() {
  if [[ ! $CYGWIN == true && ! -x $(command -v dos2unix) ]]; then
    install dos2unix make
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
  *[M/m]icrosoft* )
    green "Now Configuring WSL";
    ssh_path="$c/Users/$script_user/.ssh";
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
  Darwin* )
    green "Now Configuring Mac";
    MAC=true;;
  * )
    error "System Not Supported. Install manually.";
    exit 1;;
esac

ask_dotfile_install

# WSL Configuration
if [[ $WSL == true ]]; then
  [[ -a ~/.config/.wsl.zsh ]] && try cp ~/.config/.wsl.zsh ~/.config/.wsl.zsh.bak
  try cp $config/.wsl.zsh ~/.config/

  isInstalled tmux || install tmux
  isInstalled lsb_release || install lsb-release
  [[ `lsb_release -sd` == "Pengwin" ]] && try ask_pengwin

  git_config
  ask_npm
  copy_ssh
  success
fi # End WSL

# Mac Configuration
if [[ $MAC == true ]]; then
  [[ -a ~/.config/.mac.zsh ]] && try cp ~/.config/.mac.zsh ~/.config/.mac.zsh.bak
  try cp $config/.mac.zsh ~/.config/

  [[ ! -x `command -v tmux` ]] && install tmux

  git_config
  ask_npm
  success
fi # End WSL

# Linux Configuration
if [[ $LINUX == true ]]; then
  [[ -a ~/.config/.linux.zsh ]] && try cp ~/.config/.linux.zsh ~/.config/.linux.zsh.bak
  try cp $config/.linux.zsh ~/.config/

  [[ ! -x `command -v tmux` ]] && install tmux
  [[ ! -x `command -v lsb_release` ]] && install lsb-release

  git_config
  ask_npm
  success
fi # End Linux

# Cygwin configuration
if [[ $CYGWIN == true ]]; then
  [[ -a ~/.config/.cygwin.zsh ]] && try cp ~/.config/.cygwin.zsh ~/.config/.cygwin.zsh.bak
  try cp $config/.cygwin.zsh ~/.config/

  [[ -a ~/.minttyrc ]] && try cp ~/.minttyrc ~/.minttyrc.bak
  try cp $config/.minttyrc ~/

  # Install apt-cyg to allow easy package installation
  if [[ ! -a /bin/apt-cyg ]]; then
    try wget rawgit.com/transcode-open/apt-cyg/master/apt-cyg -P /bin/
    chmod +x /bin/apt-cyg
  fi

  install chere gdb dos2unix openssh nano zip unzip bzip2 coreutils gawk grep sed diffutils patchutils tar bash-completion ca-certificates curl rsync

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
