# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(ssh-agent, zsh-nvm, zsh-syntax-highlighting, shrink-path)

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cobalt2custom"

### User configuration ###
export PATH="$HOME/bin:/usr/local/bin:$PATH"
source $ZSH/oh-my-zsh.sh

## Custom Plugins
# N: Alternative to nvm
export N_PREFIX="$HOME/.bin/n"
[[ -x "$N_PREFIX/bin/n" ]] && [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH="$N_PREFIX/bin:$PATH"

# fzf: Fuzzy completion
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

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

# Color configuration
# LS_COLOR should contain the LS_COLORS overrides you desire.
# Override "other writable" color
OTHER_WRITABLE="ow=01;34"
# Add OTHER_WRITABLE to the end of existing LS_COLORS
LS_COLORS="$LS_COLORS:$OTHER_WRITABLE"
# Re-export LS_COLORS
export LS_COLORS

# Source OS specific configs
case `uname -a` in
  *Microsoft* )
    [[ -s ~/.wsl.zsh ]] && source ~/.wsl.zsh;;
  CYGWIN* )
    [[ -s ~/.cygwin.zsh ]] && source ~/.cygwin.zsh;;
  Linux* )
    [[ -s ~/.linux.zsh ]] && source ~/.linux.zsh;;
esac
