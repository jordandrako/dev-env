#!/bin/zsh

# Git
if [[ -x "$(command -v git)" ]]; then
  alias gs="git status -s"
  alias gss="git status"
  alias gl="git lg"
  alias ga="git add"
  alias gaa="git add -A"
  alias gac="git add -A && git commit -m"
  alias gc="git commit -m"
  alias go="git checkout"
  alias gob="git checkout -b"
  alias gol="git checkout -"
  alias gm="git merge"
  alias gml="git merge -"
  alias gp="git push"
  alias gpl="git pull"
  alias gd="git diff"
  alias gdc="git diff --cached"

  # Git finish
  gf() {
    if [[ $(git status -s | wc -l) -lt 1 ]]; then
      echo "No changes."
    elif [[ ! $1 ]]; then
      echo "You must specify a commit message!"
    elif [[ $2 && $(git ls-remote --heads origin $2 | wc -l) == 0 ]]; then
      echo "Branch \"$2\" does not exist on remote origin."
    else
      git add -A && git commit -m "$1" && [[ $2 ]] && git push origin $2
    fi
  }
else
  echo "Install git ya git!"
fi


# NPM
if [[ -x "$(command -v npm)" ]]; then
  alias ns="npm start"
  alias ni="npm i"
  alias nid="npm i -D"
  alias ngi="npm i -g"
  alias nrm="npm rm"
  alias nrmg="npm rm -g"

  # Yarn
  if [[ -x "$(command -v yarn)" ]]; then
    alias ys="yarn start"
    alias ya="yarn add"
    alias yad="yarn add -D"
    alias yrm="yarn remove"
  fi

  # Create react app
  if [[ -x "$(command -v create-react-app)" ]]; then
    alias cra="create-react-app"
    crats() {
      create-react-app $1 --typescript
    }
  elif [[ -x "$(command -v npx)" ]]; then
    alias cra="npx create-react-app"
    crats() {
      npx create-react-app $1 --typescript
    }
  fi
fi

# Docker
if [[ -x "$(command -v docker)" ]]; then
  alias dps="docker ps"
  alias dpsa="docker ps -a"
  alias drestart="docker restart"
  alias drestartall="docker restart $(docker ps -a -q)"
  alias dup="docker-compose up"
fi

# Ngrok
if [[ -x "$(command -v ngrok)" ]]; then
  alias ngr="ngrok http --host-header=rewrite"
fi

# create-react-app
if [[ -x "$(command -v create-react-app)" ]]; then
  cra_i=true
fi

# tree
if [[ -x "$(command -v tree)" ]]; then
  alias tree="tree -I 'node_modules|.git|cache'"
fi

# hassio
if [[ -x "$(command -v hassio)" ]]; then
  alias conf="cd /config"
  alias ha="hassio ha"
  alias logs="hassio ha logs"
  restart() {
    echo "Running config check..."
    hassio ha check && \
    echo "Config check passed. Restarting..." && \
    hassio ha restart $*
  }
fi

# Rush
if [[ -x "$(command -v rush)" ]]; then
  alias rb="rush build"
  alias rrb="rush rebuild"
  alias rbt="rush build -t"
  alias rbtf="rush build -t office-ui-fabric-react"
  alias rbti="rush build -t fabric-website-internal"
fi
