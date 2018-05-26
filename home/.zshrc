# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [[ ! -a $ZSH/themes/cobalt2.zsh-theme ]]; then
  wget -q https://raw.githubusercontent.com/jordandrako/dev-env/master/cobalt2.zsh-theme -P $ZSH/custom/themes/
fi
ZSH_THEME="cobalt2"

# Check system type; code/projects directory
code_dir=~/code
case "$(uname -a)" in
    Linux*Microsoft* )
      machine="Linux WSL"
      code_dir=/mnt/c/code ;;
    Linux* )
      machine="Linux" ;;
    CYGWIN* )
      machine="Cygwin"
      code_dir=c:/code ;;
    * )
      machine="UNKNOWN:${unameOut}"
esac
export CODE_DIR="$code_dir"
export MACHINE="$machine"

userprofile="$HOME"
# Cygwin settings
if [[ $machine == "Cygwin" ]]; then
  unsetopt PROMPT_SP
  userprofile="c:/Users/$USERNAME"

# WSL settings
elif [[ $machine == "Linux WSL" ]]; then
  unsetopt BG_NICE
fi
export USERPROFILE="$userprofile"

# Check for some programs
# Check if git is installed
if command -v git >/dev/null 2>&1; then
  git_i=true
else
  git_i=false
  echo "Install git ya git!"
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
if [[ ! -d $ZSH/custom/plugins/zsh-syntax-highlighting ]]; then
  if [[ $git_i == true ]]; then
    git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
    chmod -R 755 $ZSH/custom/plugins/zsh-syntax-highlighting
  fi
fi
plugins=(git, ssh-agent, node, nvm, zsh-syntax-highlighting)

# NVM Config
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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
  export EDITOR='code'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Config
alias zconf="nano ~/.zshrc"
alias zsource="source ~/.zshrc"

# Directories
alias coder="cd $CODE_DIR"
if [[ ! $machine =~ "Linux" ]]; then
  alias rm="trash"
fi

# Include alias file
if [[ -a ~/.zsh-aliases ]]; then
  source ~/.zsh-aliases
fi
