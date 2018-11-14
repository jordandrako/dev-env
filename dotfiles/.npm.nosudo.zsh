#!/bin/zsh

NPM_PACKAGES=~/.npm-global
export PATH=$NPM_PACKAGES:$PATH

unset MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"
