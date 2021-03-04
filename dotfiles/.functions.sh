#!/bin/bash

# Green background echo
green() {
  echo -e "\n\e[1;32m$1\e[0m\n"
}

# Yellow background echo
info() {
  echo -e "\n\e[1;33m$1\e[0m\n"
}

# Error echo
error() {
  echo -e "\n\e[1;5;31m$1\e[0m\n" 1>&2 && echo -ne '\007'
}

# Perform task successfully or print failed
try() {
  ( $* && success=true ) || ( success=false && error "FAILED: $*" )
}

# Ask with blue background.
# Pass question and options: `ask "question" "yes/no" readVarName`
ask() {
  if [[ ! $1 ]]; then
    error "You must pass a question to ask!"
  else
    question=$1
    input=${2:="y/n"}
    echo -e "\n\e[1;34m$question\e[0m" && echo "[$input] > "
    [[ $3 ]] && read $3
  fi
}
