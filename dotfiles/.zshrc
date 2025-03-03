# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
export PATH="$HOME/.local/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$HOME/bin:/usr/local/bin:$PATH"

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
[[ -s ~/.config/.npm.nosudo.zsh ]] && source ~/.config/.npm.nosudo.zsh

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

## TMUX
TMUX_MOTD=false

## Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit snippet OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh
zinit light zpm-zsh/tmux
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/fast-syntax-highlighting

## Aliases
alias zconf="nano ~/.zshrc"
alias zsource="source ~/.zshrc"

# Include alias file
[[ -s ~/.config/.functions.zsh ]] && source ~/.config/.functions.zsh
[[ -s ~/.config/.aliases.zsh ]] && source ~/.config/.aliases.zsh

## OS specific configs
opt=$( tr '[:upper:]' '[:lower:]' <<< `uname -a` )
case $opt in
  *microsoft* )
    [[ -s ~/.config/.wsl.zsh ]] && source ~/.config/.wsl.zsh;;
  cygwin* )
    [[ -s ~/.config/.cygwin.zsh ]] && source ~/.config/.cygwin.zsh;;
  linux* )
    [[ -s ~/.config/.linux.zsh ]] && source ~/.config/.linux.zsh;;
  darwin* )
    [[ -s ~/.config/.mac.zsh ]] && source ~/.config/.mac.zsh
esac

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

## Load Theme
# zinit light denysdovhan/spaceship-prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
