# Enable autocompletions
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
zmodload -i zsh/complist

# Save history so we get auto suggestions
HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

# Options
setopt auto_cd # cd by typing directory name if it's not a command
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances
setopt correct_all # autocorrect commands
setopt interactive_comments # allow comments in interactive shells

# Improve autocompletion style
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Customize PATH
export PATH="$HOME/bin:/usr/local/bin:$PATH"

## Custom Plugins
# fzf: Fuzzy completion
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

## Antibody
if [[ -x `command -v antibody` ]]; then
  source <(antibody init)

  # Plugins
  antibody bundle caarlos0/zsh-mkc
  antibody bundle caarlos0/zsh-git-sync
  antibody bundle caarlos0/zsh-open-github-pr
  antibody bundle robbyrussell/oh-my-zsh path:plugins/ssh-agent
  antibody bundle zdharma/fast-syntax-highlighting
  antibody bundle zsh-users/zsh-autosuggestions
  antibody bundle zsh-users/zsh-history-substring-search
  antibody bundle zsh-users/zsh-completions
  antibody bundle marzocchi/zsh-notify
  antibody bundle buonomo/yarn-completion
  antibody bundle luismayta/zsh-docker-compose-aliases
  antibody bundle Tarrasch/zsh-colors
  antibody bundle gko/ssh-connect

  # Plugins with dependencies
  [[ -x `command -v python` ]] && antibody bundle djui/alias-tips

  # Customize Theme
  SPACESHIP_CHAR_SYMBOL="❯ "
  SPACESHIP_CHAR_SYMBOL_ROOT="# "
  SPACESHIP_PROMPT_ORDER=(
    dir
    line_sep
    jobs
    exit_code
    char
  )

  SPACESHIP_RPROMPT_ORDER=(
    git
  )

  # Load Theme
  antibody bundle denysdovhan/spaceship-prompt
fi # End Antibody

## Color configuration
[[ -s ~/.dircolors ]] && eval $(dircolors -b $HOME/.dircolors)

## Aliases
alias zconf="nano ~/.zshrc"
alias zsource="clear && source ~/.zshrc"

# Include alias file
[[ -s ~/.aliases.sh ]] && source ~/.aliases.sh

## OS specific configs
case `uname -a` in
  *Microsoft* )
    [[ -s ~/.wsl.zsh ]] && source ~/.wsl.zsh;;
  CYGWIN* )
    [[ -s ~/.cygwin.zsh ]] && source ~/.cygwin.zsh;;
  Linux* )
    [[ -s ~/.linux.zsh ]] && source ~/.linux.zsh;;
esac

# Source NPM configs
[[ -s ~/.npm.nosudo.zsh ]] && source ~/.npm.nosudo.zsh

# Source RVM
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm
