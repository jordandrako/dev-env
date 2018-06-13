# Aliases
# Git
function gs
  git status -s $argv
end

function gl
  git lg $argv
end

function ga
  git add $argv
end

function gaa
  git add -A $argv
end

function gac
  git add -A
  git commit -m $argv
end

function gc
  git commit -m $argv
end

function go
  git checkout $argv
end

function gob
  git checkout -b $argv
end

function gol
  git checkout - $argv
end

function gm
  git merge $argv
end

function gml
  git merge - $argv
end

function gp
  git push $argv
end

function gpl
  git pull $argv
end

function gd
  git diff $argv
end

function gdc
  git diff --cached $argv
end
# end Git

# NPM
function ns
  npm start $argv
end

function ni
  npm i $argv
end

function nid
  npm i -D $argv
end

function ngi
  npm i -g $argv
end

function nrm
  npm rm $argv
end

function nrmg
  npm rm -g $argv
end
# end NPM

# Create react app
function cra
  if type -q create-react-app
    create-react-app $argv
  else
    npx create-react-app $argv
  end
end
function crats
  set name $argv[1]
  set --erase argv[1]
  cra $name --scripts-version=react-scripts-ts $argv
end
# end Create react app

# Yarn
function ys
  yarn start $argv
end
function ya
  yarn add $argv
end
function yad
  yarn add -D $argv
end
function yrm
  yarn remove $argv
end

# Docker
function dps
  dockera ps $argv
end
function dpsa
  dockera ps -a $argv
end
function drestart
  dockera restart $argv
end
function drestartall
  dockera restart (dockera ps -a -q) $argv
end
function dup
  docker-compose up $argv
end
# end Docker

# Ngrok
function ngr
  ngrok http --host-header=rewrite $argv
end
# end Ngrok

# Tree
function treef
  tree -I 'node_modules|.git|cache' $argv
end
# end Tree

function set_aliases
  if type -q git
    funcsave gs gl ga gaa gac gc go gob gol gm gml gp gpl gd gdc
  end
  if type -q npm
    funcsave ns ni nid ngi nrm nrmg
  end
  if type -q create-react-app
    funcsave cra crats
  end
  if type -q yarn
    funcsave ys ya yad yrm
  end
  if type -q dockera
    funcsave dps dpsa drestart drestartall dup
  end
  if type -q ngrok
    funcsave ngr
  end
  if type -q tree
    funcsave treef
  end
end