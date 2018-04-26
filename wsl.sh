#!/bin/bash

# Ask for permanent passwordless sudo
echo -ne '\007'
while true; do
    read -p "Do you want permanent sudo? Answering no will result in you having to type your password every log in. [y/N]" yn
    case $yn in
        [Yy]* ) sudo su -c "echo '$USER ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers"; break;;
        [Nn]* ) break;;
        * ) break;;
    esac
done

# Perform task successfully or print failed
successfully() {
	$* || ( echo -e "\n\e[1;5;41mFAILED\e[0m\n" 1>&2 && echo -ne '\007' && exit 1 )
}
# Echo with color
fancy_echo() {
	echo -e "\n\e[1;42m$1\e[0m\n"
}

fancy_echo "Updating, installing packages, and setting up environment. This may take a while..."
  # Latest version of Git
  successfully sudo add-apt-repository ppa:git-core/ppa -y
  # Install Node v8 and npm
  curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  # Update and upgrade
  successfully sudo apt -q update && sudo apt -q upgrade -y
  successfully sudo apt autoremove -y
  # Install packages
  successfully sudo apt -q install zsh git nodejs apt-transport-https ca-certificates unzip python-pip python-dev build-essential -y

  # Add pip
  successfully sudo -H pip install --upgrade pip virtualenv
  successfully pip install --user powerline-status
  # Add local stuff to path before the rest and mount script
  successfully sed -i.bak '/PATH=/d' ~/.profile
  cat assets/.profile >> ~/.profile
  # Make npm install packages in home folder (no sudo for npm install --global)
  #successfully mkdir ~/.npm-packages
  # Make nano useable. Line numbers, smooth scrolling, better indentation
  successfully cp assets/.nanorc ~/.nanorc
  cat assets/.npmrc >> ~/.npmrc

fancy_echo "Configuring git"
  # Ask for Git config details
  fancy_echo "What's your first and last name (for git)?"
  read gitname1 gitname2
  gitname="$gitname1 $gitname2"
  fancy_echo "What's your email (for git)?"
  read gitemail
  git config --global user.name "$gitname"
  git config --global user.email $gitemail
  # Better git log
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
  # Ignore line endings between Windows and linux in commits.
  echo "* -text" > ~/.gitattributes

# Mount --bind /mnt/c and /mnt/d to /. This helps some linux programs map to windows programs better, such as docker.
fancy_echo "Mounting C drive to /"
  if [ ! -d "/c" ]; then
    successfully sudo mkdir /c
  fi
  successfully sudo mount --bind /mnt/c /c
  if [ -d "/mnt/d" ]; then
    if [ ! -d "/d" ]; then
      successfully sudo mkdir /d
    fi
    successfully sudo mount --bind /mnt/d /d
  fi

fancy_echo "Downloading/copying assets"
  # Make /c/dev folder if it doesn't exist
  if [ ! -d "/c/dev" ]; then
    mkdir /c/dev
  fi
  # Clone Fira Code and Source Code Pro for Powerline
  if [ -d "/c/dev/FiraCode" ]; then
    rm -rf /c/dev/FiraCode
  fi
  successfully git clone -q https://github.com/tonsky/FiraCode.git /c/dev/FiraCode
  successfully cp assets/SourceCodeProPowerline.otf /c/dev/FiraCode/distr/otf/
  # Example PATH variables for windows
  successfully cp assets/DEVPATH.md /c/dev/DEVPATH.md
  # SSH-Agent automatically open agent and add keys if not already added (not currently in use, using oh-my-zsh ssh-agent plugin instead)
  successfully cp assets/.agent ~/.agent
  successfully chmod +x ~/.agent
  # Mounting script called from ~/.bashrc (same as above, since it needs to be mounted on every boot)
  successfully cp assets/.mount ~/.mount
  successfully chmod +x ~/.mount

fancy_echo "Configuring Zsh"
  # Ask if Zsh should be default shell
  successfully cp ~/.bashrc ~/.bashrc.bak
  echo -ne '\007'
  while true; do
    read -p "Have Bash launch ZSH on startup? (Workaround until chsh is built into wsl [Windows build]) [y/N]" yn
    case $yn in
      # If yes add mount and zsh to end of .bashrc
      [Yy]* ) echo "if [ -t 1 ]; then" >> ~/.bashrc; echo "  exec zsh" >> ~/.bashrc; echo "fi" >> ~/.bashrc; break;;
      # If no only add mount to end of .bashrc
      * ) break;;
    esac
  done
  # Install Oh-My-Zsh
  successfully curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  # Install my fork of Cobalt2 zsh theme with glyphs for Fira and Windows
	successfully curl https://raw.githubusercontent.com/jordandrako/Cobalt2-iterm/master/cobalt2.zsh-theme -o ~/.oh-my-zsh/themes/cobalt2.zsh-theme
  # Install oh-my-zsh plugin version of zsh-syntax-highlighting (fish like syntax highlighting for zsh)
	successfully git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  # Copy my .zshrc
	successfully cp ~/.zshrc ~/.zshrc.bak
	successfully cp zsh/.zshrc ~/.zshrc
  # Add mount script to .zprofile
  cat zsh/.zprofile >> ~/.zprofile

# Still the best terminal emulator for windows
fancy_echo "Install Cmder"
  # Get fresh zip
  if [ -f "/c/dev/cmder_mini.zip" ]; then
    successfully rm /c/dev/cmder_mini.zip
  fi
  successfully curl -LOk https://github.com/cmderdev/cmder/releases/download/v1.3.2/cmder_mini.zip
  # Unzip it
  successfully unzip cmder_mini.zip -d /c/cmder; rm cmder_mini.zip
  # Copy my config files to fresh install. Includes:
  # OneDark color scheme, Cobalt2 color scheme, bash as default terminal task,
  # Powerline like prompt for CMD, SSH-Agent on start, useful aliases, etc
  successfully cp -r cmder /c/

# If you want your local machine id_rsa key to be used by bash
fancy_echo "Do you want your local user (windows) id_rsa ssh keys in bash?"
echo -ne '\007'
while true; do
    read -p "Copy your windows ssh key? [y/N]" yn
    case $yn in
        [Yy]* ) ssh-keygen; cat "/c/Users/$USER/.ssh/id_rsa" > "$HOME/.ssh/id_rsa"; cat "/c/Users/$USER/.ssh/id_rsa.pub" > "$HOME/.ssh/id_rsa.pub"; break;;
        [Nn]* ) break;;
        * ) break;;
    esac
done

fancy_echo "All Done! Exit bash and relaunch, then continue on with the steps in the README."
