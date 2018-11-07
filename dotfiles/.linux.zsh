#!/bin/zsh

## Linux configs
export CODE_DIR=~/code
export MACHINE="Linux"
[[ `lsb_release -sd | wc -l` -gt 0 ]] && OS="| OS: `lsb_release -sd`"
echo -e "Welcome $USER! | Machine: $MACHINE $OS\n"

alias coder="cd $CODE_DIR"
