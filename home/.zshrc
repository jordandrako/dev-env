# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ ! -a $ZSH/themes/cobalt2.zsh-theme ]]; then
  wget -q https://raw.githubusercontent.com/jordandrako/Cobalt2-iterm/master/cobalt2.zsh-theme -P $ZSH/themes/
fi
ZSH_THEME="cobalt2"

# Check system
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine="Linux";;
    Darwin*)    machine="Mac";;
    CYGWIN*)    machine="Cygwin";;
    MINGW*)     machine="MinGw";;
    *)          machine="UNKNOWN:${unameOut}"
esac
export MACHINE="$machine"

# Windows settings
if [[ $machine == "Cygwin" ]]; then
  unsetopt PROMPT_SP
  userprofile="c:/Users/$USERNAME"

# Linux settings
elif [[ $machine == "Linux" ]]; then
  userprofile="$HOME"
fi
export USERPROFILE="$userprofile"

# Check for some programs
# Check if git is installed
if command -v git >/dev/null 2>&1; then
  git_installed=true
else
  git_installed=false
  echo "Install git ya git!"
fi

# Check if npm is installed
if command -v npm >/dev/null 2>&1; then
  npm_installed=true
else
  npm_installed=false
fi

# Check if yarn is installed
if command -v yarn >/dev/null 2>&1; then
  yarn_installed=true
else
  yarn_installed=false
fi

# Check if docker is installed
if command -v docker >/dev/null 2>&1; then
  docker_installed=true
else
  docker_installed=false
fi

# Check if ngrok is installed
if command -v ngrok >/dev/null 2>&1; then
  ngrok_installed=true
else
  ngrok_installed=false
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ ! -d $ZSH/custom/plugins/zsh-syntax-highlighting ]]; then
  if [[ $git_installed == true ]]; then
    git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
  fi
fi
plugins=(git, ssh-agent, node, zsh-syntax-highlighting)

### User configuration ###
export PATH="$USERPROFILE/bin:/usr/local/bin:$PATH"
source $ZSH/oh-my-zsh.sh

# z plugin
if [[ -a ~/.bin/z.sh ]]; then
  . ~/.bin/z.sh
else
  mkdir -p ~/.bin
  wget -q https://raw.githubusercontent.com/rupa/z/master/z.sh -O ~/.bin/z.sh
  chmod +x ~/.bin/z.sh
  . ~/.bin/z.sh
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# Code/projects directory
code_dir=$USERPROFILE/code
if [[ ! -d $code_dir ]]; then
  mkdir $USERPROFILE/code
fi
export CODE_DIR="$code_dir"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Config
alias zconf="nano ~/.zshrc"
alias zsource="source ~/.zshrc"

# Directories
alias coder="cd $CODE_DIR"
if [[ $machine == "Linux" ]]; then
  alias rimraf="rm -rf"
else
  alias rimraf="trash"
fi

# Git
if [[ $git_installed == true ]]; then
  alias gs="git status -s"
  alias gl="git lg"
  alias ga="git add"
  alias gaa="git add --all"
  alias gac="git commit -am"
  alias gc="git commit -m"
  alias go="git checkout"
  alias gob="git checkout -b"
  alias gol="git checkout -"
  alias gm="git merge"
  alias gml="git merge -"
  alias gp="git push"
  alias gpl="git pull"
fi

# NPM
if [[ $npm_installed == true ]]; then
  alias ns="npm start"
  alias ni="npm i"
  alias nig="npm i -g"
  alias nrm="npm rm"
  alias nrmg="npm rm -g"
fi
if [[ $yarn_installed == true ]]; then
  alias ys="yarn start"
  alias ya="yarn add"
  alias yad="yarn add -D"
  alias yrm="yarn remove"
fi

# Docker
if [[ $docker_installed == true ]]; then
  alias dps="docker ps"
  alias dpsa="docker ps -a"
  alias drestart="docker restart"
  alias drestartall="docker restart $(docker ps -a -q)"
  alias dup="docker-compose up"
fi

# Ngrok
if [[ $ngrok_installed == true ]]; then
  alias ngr="ngrok http --host-header=rewrite"
fi

function start() {
  if [[ $yarn_installed == true && ( $1 == "-y" || -a "$PWD/yarn.lock" ) ]]; then
    yarn start
  elif [[ $npm_installed == true && ( $1 == "-n" || -a "$PWD/package-lock.json" ) ]]; then
    npm start
  elif [[ $yarn_installed == true && $1 == "-i" ]]; then
    yarn && yarn start
  elif [[ $npm_installed == true && $1 == "-I" ]]; then
    npm i && npm start
  else
    echo "Run your install script first, and the program you want is installed."
    echo "Force with: -y = yarn, -n = npm. Install and start with: -i = yarn, -I = npm."
  fi
}
