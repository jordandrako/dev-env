# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cobalt2"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git, ssh-agent, node, nvm, zsh-syntax-highlighting)

### User configuration ###
export PATH="$HOME/bin:/usr/local/bin:$PATH"
source $ZSH/oh-my-zsh.sh

# NVM Config
export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# z plugin
export Z_DIR="$HOME/.bin"
[ -s "$Z_DIR/z.sh" ] && \. "$Z_DIR/z.sh"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='code'
fi

# Color configuration
# LS_COLOR should contain the LS_COLORS overrides you desire.
# Override "other writable" color
LS_COLOR="ow=01;34"
# Add LS_COLOR to the end of existing LS_COLORS
LS_COLORS="$LS_COLORS:$LS_COLOR"
# Re-export LS_COLORS
export LS_COLORS

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Config
alias zconf="nano ~/.zshrc"
alias zsource="source ~/.zshrc && clear"

# Include alias file
if [[ -a ~/.aliases.sh ]]; then
  source ~/.aliases.sh
fi
