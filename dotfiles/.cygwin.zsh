#!/bin/zsh

## Cygwin configs
unsetopt PROMPT_SP
export CODE_DIR=/cygdrive/c/code
export MACHINE="Cygwin"
echo -e "Welcome $USER! | Machine: $MACHINE\n"

# Nodist
nodist_dir="/cygdrive/c/Program Files (x86)/Nodist"
[[ -a "$nodist_dir/bin/nodist_bash_profile_content.sh" ]] && source "$nodist_dir/bin/nodist_bash_profile_content.sh"

alias apt="apt-cyg"
alias coder="cd $CODE_DIR"
alias nsfi="cd $CODE_DIR && cd ui-fabric-website-internal/apps/fabric-website-internal && npm start"
