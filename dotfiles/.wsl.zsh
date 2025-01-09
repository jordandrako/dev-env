#!/usr/bin/zsh

## WSL configs
unsetopt BG_NICE
export MACHINE="WSL"
[[ -d ~/code ]] && export CODE_DIR=~/code

alias coder="cd $CODE_DIR"

if [[ -x "$(command -v cmd.exe)" ]]; then
  alias cmd="cmd.exe"
fi
