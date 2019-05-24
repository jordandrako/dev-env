#!/bin/zsh

## WSL configs
unsetopt BG_NICE
export MACHINE="WSL"
[[ -d /c && -d /c/code && -n `ls -a /c/code` ]] && export CODE_DIR=/c/code || export CODE_DIR=/mnt/c/code

alias coder="cd $CODE_DIR"
alias nsfi="cd $CODE_DIR && cd ui-fabric-website-internal/apps/fabric-website-internal && npm start"

if [[ -x "$(command -v cmd.exe)" ]]; then
  alias cmd="cmd.exe"
  alias x410="cmd.exe /c 'start x410.exe'"
  alias xkill="cmd.exe /c 'taskkill /IM x410.exe'"
  alias xdesktop="cmd.exe /c 'taskkill /IM x410.exe' && cmd.exe /c 'start x410 /desktop'"
fi

if [[ -x "$(command -v docker.exe)" && ! -x "$(command -v docker)" ]]; then
  alias docker="docker.exe"
fi

[[ -s ~/.xsrv.zsh ]] && source ~/.xsrv.zsh

if [[ -d $HOME/.rbenv/bin ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
fi
