#!/bin/zsh

# Check for some programs
# Check if git is installed
if command -v git >/dev/null 2>&1; then
  git_i=true
else
  echo "Install git ya git!"
fi

# Check if npm is installed
[[ -x "$(command -v npm)" ]] && npm_i=true

# Check if yarn is installed
[[ -x "$(command -v yarn)" ]] && yarn_i=true

# Check if docker is installed
[[ -x "$(command -v docker)" ]] && docker_i=true

# Check if ngrok is installed
[[ -x "$(command -v ngrok)" ]] && ngrok_i=true

# Check if create-react-app is installed
[[ -x "$(command -v create-react-app)" ]] && cra_i=true

# Check if tree is installed
[[ -x "$(command -v tree)" ]] && tree_i=true

# Aliases
# Git
if [[ $git_i ]]; then
  alias gs="git status -s"
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
fi # end Git

# NPM
if [[ $npm_i ]]; then
  alias ns="npm start"
  alias ni="npm i"
  alias nid="npm i -D"
  alias ngi="npm i -g"
  alias nrm="npm rm"
  alias nrmg="npm rm -g"

  # Create react app
  if [[ $cra_i ]]; then
    alias cra="create-react-app"
    crats() {
      create-react-app $1 --scripts-version=react-scripts-ts
    }
  else
    alias cra="npx create-react-app"
    crats() {
      npx create-react-app $1 --scripts-version=react-scripts-ts
    }
  fi

  # Yarn
  if [[ $yarn_i ]]; then
    alias ys="yarn start"
    alias ya="yarn add"
    alias yad="yarn add -D"
    alias yrm="yarn remove"
  fi
fi # end NPM

# Docker
if [[ $docker_i ]]; then
  alias dps="docker ps"
  alias dpsa="docker ps -a"
  alias drestart="docker restart"
  alias drestartall="docker restart $(docker ps -a -q)"
  alias dup="docker-compose up"
fi

# Ngrok
if [[ $ngrok_i ]]; then
  alias ngr="ngrok http --host-header=rewrite"
fi

# Tree
if [[ $tree_i ]]; then
  alias tree="tree -I 'node_modules|.git|cache'"
fi

