# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(ssh-agent, zsh-syntax-highlighting, shrink-path)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cobalt2custom"

### User configuration ###
export PATH="$HOME/bin:/usr/local/bin:$PATH"
source $ZSH/oh-my-zsh.sh

# N Init
export N_PREFIX="$HOME/.bin/n"
[[ -x "$N_PREFIX/bin/n" ]] && [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH="$N_PREFIX/bin:$PATH"

# z plugin
export Z_DIR="$HOME/.bin"
loadz() {
  if [[ -d $NVM_DIR ]]; then
    [[ -s "$Z_DIR/z.sh" ]] && \. "$Z_DIR/z.sh"
    echo "Z loaded, run last command again."
  else
    echo "Z not installed"
  fi
}

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='nano'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# Config
alias zconf="nano ~/.zshrc"
alias zsource="clear && source ~/.zshrc"

# Include alias file
[[ -s ~/.aliases.sh ]] && source ~/.aliases.sh
