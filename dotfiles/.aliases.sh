#!/bin/zsh

# Check for some programs
# Check if git is installed
if command -v git >/dev/null 2>&1; then
  git_i=true
else
  git_i=false
  echo "Install git ya git!"
fi

# Check if npm is installed
if command -v npm >/dev/null 2>&1; then
  npm_i=true
else
  npm_i=false
fi

# Check if yarn is installed
if command -v yarn >/dev/null 2>&1; then
  yarn_i=true
else
  yarn_i=false
fi

# Check if docker is installed
if command -v docker >/dev/null 2>&1; then
  docker_i=true
else
  docker_i=false
fi

# Check if ngrok is installed
if command -v ngrok >/dev/null 2>&1; then
  ngrok_i=true
else
  ngrok_i=false
fi

# Check if create-react-app is installed
if command -v create-react-app >/dev/null 2>&1; then
  cra_i=true
else
  cra_i=false
fi

# Check if tree is installed
if command -v tree >/dev/null 2>&1; then
  tree_i=true
else
  tree_i=false
fi

# Aliases
# Git
if [[ $git_i == true ]]; then
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
if [[ $npm_i == true ]]; then
  alias ns="npm start"
  alias ni="npm i"
  alias ngi="npm i -g"
  alias nrm="npm rm"
  alias nrmg="npm rm -g"

  # Create react app
  if [[ $cra_i == true ]]; then
    alias cra="create-react-app"
  else
    alias cra="npx create-react-app"
  fi
  # CRA typescript
  function crats() {
    cra $1 --scripts-version=react-scripts-ts
  }

  # Yarn
  if [[ $yarn_i == true ]]; then
    alias ys="yarn start"
    alias ya="yarn add"
    alias yad="yarn add -D"
    alias yrm="yarn remove"
  fi
fi # end NPM

# Docker
if [[ $docker_i == true ]]; then
  alias dps="docker ps"
  alias dpsa="docker ps -a"
  alias drestart="docker restart"
  alias drestartall="docker restart $(docker ps -a -q)"
  alias dup="docker-compose up"
fi

# Ngrok
if [[ $ngrok_i == true ]]; then
  alias ngr="ngrok http --host-header=rewrite"
fi

# Tree
if [[ $tree_i == tree ]]; then
  alias tree="tree -I 'node_modules|.git|cache'"
fi

