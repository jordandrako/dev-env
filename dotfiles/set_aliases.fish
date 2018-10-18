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

function gf
  if [ (git status -s | wc -l) -lt 1 ]
    echo "No changes."
  else if [ $argv[3] ]
    echo "Too many arguments."
  else if [ ! $argv[1] ]
    echo "You must specify a commit message!"
  else if begin [ $argv[2] ]; and [ (git ls-remote --heads origin $argv[2] | wc -l) -lt 1 ]; end
    echo "Branch \"$argv[2]\" does not exist on remote origin."
  else
    git add -A; and git commit -m "$argv[1]"; and [ $argv[2] ]; and git push origin $argv[2]
  end
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

# Hassio
function conf
  cd /config $argv
end

function ha
  hassio ha $argv
end

function restart
  echo "Running config check..."
  hassio ha check
  and echo "Config check passed. Restarting..."
  and hassio ha restart $argv
end

function logs
  hassio ha logs $argv
end
# end Hassio

function set_aliases
  if type -q git
    funcsave gs gl ga gaa gac gc go gob gol gm gml gp gpl gd gdc gf
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

  if type -q hassio
    funcsave conf ha restart logs
  end
end