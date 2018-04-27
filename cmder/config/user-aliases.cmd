;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
e.=explorer .
ls=ls --show-control-chars -F --color $*
pwd=cd
clear=cls
history=cat "%CMDER_ROOT%\config\.history"
unalias=alias /d $1
vi=vim $*
cmderr=cd /d "%CMDER_ROOT%"

;= Directories
wwwr=cd /d "%USERPROFILE%/www"
coder=cd /d "%USERPROFILE%/code"
rimraf=rm -rf
..=cd ..
...=cd ../..
....=cd ../../..

;= SSH
restartplex=ssh server1 'docker restart Plex'

;= Git
gs=git status -s $*
gsa=git status $*
gl=git lg $*
ga=git add $*
gaa=git add --all $*
gac=git commit -am $*
gc=git commit -m $*
go=git checkout $*
gob=git checkout -b $*
gol=git checkout - $*
gm=git merge $*
gml=git merge - $*
gp=git push $*
gpl=git pull $*

;= NPM
nig=npm i -g $*
nrm=npm rm -g $*

;= Docker
dps=docker ps $*
dpsa=docker ps -a $*
dre=docker restart $*
dup=docker-compose up $*

;= Ngrok
ngr=ngrok http --host-header=rewrite $1
