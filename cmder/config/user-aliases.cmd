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
shell="%CMDER_ROOT%\shellchooser.bat"
xdesktop="%CMDER_ROOT%\bat-launcher.vbs start-wlinux-xfce-desktop"

;= Directories
coder=cd /d "%CODE_DIR%"
la=ls -la $*
..=cd ..
...=cd ../..
....=cd ../../..

;= Git
gs=git status -s $*
gss=git status $*
gl=git lg $*
ga=git add $*
gaa=git add -A $*
gac=git add -A && git commit -am $*
gc=git commit -m $*
go=git checkout $*
gob=git checkout -b $*
gol=git checkout - $*
gm=git merge $*
gml=git merge - $*
gp=git push $*
gpl=git pull $*
gd=git diff $*
gdc=git diff --cached $*
gf=git add -A && git commit -m $* && git push
git-NUKE=git reset --hard HEAD && git clean -fdq

;= NPM
ns=npm start $*
ni=npm i $*
nid= npm i -D $*
ngi=npm i -g $*
nrm=npm rm $*
nrmg=npm rm -g $*
nsfi=cd /d "%CODE_DIR%\ui-fabric-website-internal\apps\fabric-website-internal" && npm start

;= Create react app
cra=create-react-app $*
crats=create-react-app $1 --typescript

;= Yarn
ys=yarn start $*
ya=yarn add $*
yad=yarn add -D $*
yrm=yarn remove $*

;= Docker
dps=docker ps $*
dpsa=docker ps -a $*
drestart=docker restart $*
dup=docker-compose up $*

;= Ngrok
ngr=ngrok http --host-header=rewrite $1

;= Rush
rb=rush build $*
rrb=rush rebuild $*
rbt=rush build -t $*
rbtf=rush build -t office-ui-fabric-react $*
rbti=rush build -t fabric-website-internal $*
