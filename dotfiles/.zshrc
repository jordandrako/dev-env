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
autoload -U history-search-end
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N history-beginning-backward-end history-search-end
zle -N history-beginning-forward-end history-search-end
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "\e[3~" delete-char


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
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/bin:/usr/local/bin:$PATH"

## Custom Plugins
# fzf: Fuzzy completion
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# Java: SDKMan
[[ -f ~/.sdkman/bin/sdkman-init.sh ]] && source ~/.sdkman/bin/sdkman-init.sh
[[ -f ~/.sdkman/candidates/java/current ]] && export JAVA_HOME=~/.sdkman/candidates/java/current

# RVM: Ruby version manager
[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm

# Source NPM configs
[[ -d ~/n/bin ]] && export PATH=~/n/bin:$PATH
[[ -s ~/.npm.nosudo.zsh ]] && source ~/.npm.nosudo.zsh

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

## Antibody
if [[ -x `command -v antibody` ]]; then
  source <(antibody init)

  # Plugins
  antibody bundle caarlos0/zsh-git-sync
  antibody bundle robbyrussell/oh-my-zsh path:plugins/ssh-agent
  antibody bundle zdharma/fast-syntax-highlighting
  antibody bundle zsh-users/zsh-autosuggestions
  antibody bundle zsh-users/zsh-history-substring-search
  antibody bundle zsh-users/zsh-completions
  antibody bundle buonomo/yarn-completion
  antibody bundle luismayta/zsh-docker-compose-aliases

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

## Aliases
alias zconf="nano ~/.zshrc"
alias zsource="clear && source ~/.zshrc"

# Include alias file
[[ -s ~/.aliases.sh ]] && source ~/.aliases.sh

## OS specific configs
opt=$( tr '[:upper:]' '[:lower:]' <<< `uname -a` )
case $opt in
  *microsoft* )
    [[ -s ~/.wsl.zsh ]] && source ~/.wsl.zsh;;
  cygwin* )
    [[ -s ~/.cygwin.zsh ]] && source ~/.cygwin.zsh;;
  linux* )
    [[ -s ~/.linux.zsh ]] && source ~/.linux.zsh;;
  darwin* )
    [[ -s ~/.mac.zsh ]] && source ~/.mac.zsh
esac

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
