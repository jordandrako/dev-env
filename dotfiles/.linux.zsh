#!/bin/zsh

## Linux configs
export MACHINE="Linux"
export CODE_DIR=~/code

alias coder="cd $CODE_DIR"

[[ -x "$(command -v lsb_release)" ]] && [[ `lsb_release -sd | wc -l` -gt 0 ]] && OS="| OS: `lsb_release -sd`"
echo -e "Welcome $USER! | Machine: $MACHINE $OS\n"
