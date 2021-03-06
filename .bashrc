# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PATH=$PATH:$HOME/bin:/usr/sbin:$HOME/bin/php_templates:/opt/cuda/bin:/opt/grails/bin

# User specific aliases and functions

#alias rm='rm -i'
alias rr='rm -rf'
#alias cp='cp -i'
#alias mv='mv -i'

alias ts='ts "%H:%M:%.S"'

alias ndrpm='rpm -Uhv --excludedocs'
alias rf='rpm -qf'
alias rq='rpm -q'

alias g='LANG=en_US.utf8 git'
# Provide also completions like in git
# http://stackoverflow.com/questions/342969/how-do-i-get-bash-completion-to-work-with-aliases
. /usr/share/bash-completion/completions/git
__git_complete g __git_main
alias b='source ~/.bashrc'
alias d=docker
alias s=sleep
alias e=mcedit
alias l='ln -s'

alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

alias fpaste='fpaste -n Hubbitus'

alias ll='ls -l --color=auto'

alias fly='gradle -b standalone.gradle flywayRepair ; gradle -b standalone.gradle flywayMigrate -i | /usr/bin/ts "%H:%M:%.S"'

# Allow user aliases in sudo http://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

alias yum='nice -n19 yum'

alias ap=ansible-playbook

alias en='export LANG=en_US.utf8'

alias idea=/opt/idea/bin/idea.sh

alias gw='./gradlew'

rpmbuild (){
	ionice -c3 nice -n18 /usr/bin/rpmbuild "$@" | egrep "Записан:|Wrote:" | cut -d" " -f2 | xargs -rI{} sh -c 'F="{}"; echo "rpmlint of: $F"; rpmlint "$F"'
}

alias rtorrent='ionice -c3 nice -n17 rtorrent'

#alias mplayer='mplayer -framedrop -zoom -fs'
alias gmplayer='gmplayer -framedrop -zoom'

#alias screen='screen -OaUx main || screen -OaU -S main'
#alias screen-remote='/usr/bin/screen -OaUx Remote || /usr/bin/screen -OaU -S Remote -c /home/pasha/.screenrc-remote'

#alias jiracli="/home/pasha/imus/imus-tools.GIT/JiraCli/jira-cli-3.7.0/jira.sh --server http://serverprog:1090/ --user p.alexeev --password $(cat /home/pasha/imus/imus-tools.GIT/JiraCli/.password)"

# Function instead of alias to behave identically on remote and local execution
# http://www.thelinuxlink.net/pipermail/lvlug/2005-July/014629.html
function screen(){
	/usr/bin/screen -OaUx Main $@ || /usr/bin/screen -OaU -S Main $@
}

function screen-remote(){
	/usr/bin/screen -OaUx Remote || /usr/bin/screen -OaU -S Remote -c ~/.screenrc-remote
}

function screen-rgc(){
	/usr/bin/screen -OaUx Rgc || /usr/bin/screen -OaU -S Rgc -c ~/.screenrc-rgc
}

function screen-egais(){
	/usr/bin/screen -OaUx Egais || /usr/bin/screen -OaU -S Rgc -c ~/.screenrc-egais
}

function screen-rlh(){
	/usr/bin/screen -OaUx Rlh || /usr/bin/screen -OaU -S Rgc -c ~/.screenrc-rlh
}

# http://stackoverflow.com/questions/6064548/send-commands-to-a-gnu-screen
# http://stackoverflow.com/questions/6510673/in-screen-how-do-i-send-a-command-to-all-virtual-terminal-windows-within-a-sing
function rgc-screen-all-command(){
	/usr/bin/screen -S Rgc -X at '#' stuff "$@
"
}

alias ssh-agent='eval `SSH_AGENT_REUSE_MUST_BE_SOURCED='' /home/pasha/bin/ssh-agent-reENV.bash`'

alias sus="su -l -c 'screen -x || screen'"

alias rsync_s='source ~/.rsync_shared_options ; ionice -c3 nice -n19 rsync $RSYNC_SHARED_OPTIONS'

alias grin='grin --force-color'

alias св=cd

# Nice to long time test: gotar, modarcon16*, modarin256* (with root), nicedark, xoria256 + transparent background in ini
# Until https://bugzilla.redhat.com/show_bug.cgi?id=1288446 resolved it can't be 256 color
#alias mc='TERM=xterm-256color mc -x --skin=gotar'
alias mc='TERM=screen-256color mc -x --skin=modarcon16'

alias yakuake='yakuake.start.dbus'

# On my note disk is very slow and multitread java very overload it
alias java='nice -n19 ionice -c3 java'

alias svn='ionice -c3 colorsvn'

#function svn(){
#	colorsvn "$@" | colordiff
#}

alias t='cd ~/temp'

# Idea diff and merge  http://www.jetbrains.com/idea/webhelp/running-intellij-idea-as-a-diff-or-merge-command-line-tool.html
alias idiff='/opt/idea/bin/idea.sh diff'
alias imerge='/opt/idea/bin/idea.sh merge'

# If at that moment yakuake active and NOT start from | (to allow manually name it later) - set it title to first argument of ssh* command (user@host assummed)
function setYakuakeTabName(){

local sessionId="$( qdbus org.kde.yakuake /yakuake/sessions activeSessionId )"

	[ 'true' == "$( qdbus org.kde.yakuake /yakuake/MainWindow_1 org.qtproject.Qt.QWidget.isActiveWindow )" ] && \
		[ '|' != "$( qdbus org.kde.yakuake /yakuake/tabs tabTitle $sessionId | cut -c1 )" ] && \
			qdbus org.kde.yakuake /yakuake/tabs setTabTitle $sessionId "$1"
}

function ssh(){
	setYakuakeTabName "$1"
	/usr/bin/ssh $@
}

function sshs(){
	ssh $@ -t 'screen -x || screen'
}

# while.cmd from https://github.com/Hubbitus/shell.scripts
function whilessh(){
	WHILE_CMD_PRE_EXECUTE="setYakuakeTabName $1" while.cmd /usr/bin/ssh $@
}

# while.cmd from https://github.com/Hubbitus/shell.scripts
#No NOT jjust "alias whilesshs='while.cmd sshs'" because it will call tab name set on each try!
function whilesshs(){
	WHILE_CMD_PRE_EXECUTE="setYakuakeTabName $1" while.cmd /usr/bin/ssh $@ -t 'screen -x || screen'
}

complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" ssh
complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" sshs
complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" whilessh
complete -W "$( grep -hoP '(?<=^Include ).+' ~/.ssh/config <( echo 'Include $HOME/.ssh/config' ) | xargs -I{} sh -c 'F="{}"; [ ! -f "$F" ] && F="$HOME/.ssh/$F" ; grep -oP "(?<=^Host ).+" "$F"' )" whilesshs

# #1 - videofilename
function seen(){
: ${1?"You must provide argument: `basename $0` target-video-file"}

	touch "$1.seen" && rm -f "$1"
}

#http://rusmafia.org/linux/node/21
shopt -s cdspell

#+3 http://tigro.info/blog/index.php?id=418
shopt -s histappend
#PROMPT_COMMAND='history -a'

#http://stasikos.livejournal.com/tag/mc Remove trash from MC
#export HISTCONTROL="ignoredups"
export HISTCONTROL=ignoreboth

#Auto start ssh-agent. http://rusmafia.org/linux/ssh-agent-shell-startup
##[ ! -S ~/.ssh/ssh-agent ] && eval `/usr/bin/ssh-agent -a ~/.ssh/ssh-agent`
##[ -z $SSH_AUTH_SOCK ] && export SSH_AUTH_SOCK=~/.ssh/ssh-agent
## Auto start now performed by local alias with reusing existence socket!

#ssh-agent #just execute, alias redefined before.
	# On my home machine alias before defined (znd alias show it properly), but in this line (or file?)
	# call by it is not worked :( See example ~/bin/SHARED/examples/bash-alias.test
	# So, directly get and exec value:
	[ alias ssh-agent &>/dev/null ] && $( alias ssh-agent | sed -r "s/^alias ttt='(.*)'/\1/" )
	# '

# http://wiki.clug.org.za/wiki/Colour_on_the_command_line#Colourful_manpages_.28RedHat_style.29
# For colourful man pages (CLUG-Wiki style)
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

SVN='svn+ssh://x-www.info/mnt/sgtBarracuda/SVN_test/svn/repositories/'

export EDITOR=mcedit

export IMUS_MULE_2_1='/opt/mule-standalone-3.2.0'
export MULE_BASE='/opt/mule-standalone-3.2.0'
export IMUS_HOME='/home/pasha/imus'

# For Grails
#export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64/
#?export JAVA_HOME=/usr/java/latest/
unset JAVA_HOME
export GRAILS_HOME=/opt/grails/
[ -f /opt/grails/grails_autocomplete ] && . /opt/grails/grails_autocomplete


# http://openite.com/ru/Development/2013/01/08/ispravlenie-otobrazheniya-shriftov-v-produktah-jetbrains.html
# http://pgserious.blogspot.ru/2012/10/java-linux.html
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
# -Dsun.java2d.pmoffscreen=false, -XX:+UseCompressedOops from http://devnet.jetbrains.com/docs/DOC-192
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops'
# http://habrahabr.ru/post/160049/ add -XX:+DoEscapeAnalysis, -XX:+AggressiveOpts, -XX:+UseCompressedStrings (tried: OpenJDK 64-Bit Server VM warning: ignoring option UseCompressedStrings; support was removed in 7.0) -XX:+UseStringCache -XX:+EliminateLocks
# dropped: -XX:+UseStringCache because: OpenJDK 64-Bit Server VM warning: ignoring option UseStringCache; support was removed in 8.0
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops -XX:+DoEscapeAnalysis -XX:+AggressiveOpts -XX:+EliminateLocks'
# Try enable -XX:+UseParallelGC -XX:+UseNUMA and -XX:+TieredCompilation by http://docs.oracle.com/javase/7/docs/technotes/guides/vm/performance-enhancements-7.html#compressedOop
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops -XX:+DoEscapeAnalysis -XX:+AggressiveOpts -XX:+EliminateLocks -XX:+UseParallelGC -XX:+UseNUMA -XX:+TieredCompilation'
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.pmoffscreen=false -XX:+UseCompressedOops -XX:+DoEscapeAnalysis -XX:+AggressiveOpts -XX:+EliminateLocks -XX:+UseNUMA -XX:+TieredCompilation'
# @TODO try: -XX:+UseG1GC -XX:+UseStringDeduplication http://javapoint.ru/presentations/jpoint-April2015-string-catechism.pdf (http://javapoint.ru/materials/)

# Force debugging:
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5007'
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5007'


# For run groovy scripts and load classes from current directory
# http://testinfected.blogspot.ru/2008/01/dry-groovy-how-to-get-groovy-to-import.html
export CLASSPATH=$CLASSPATH:.

# Do not auto update screen titles!
export PROMPT_COMMAND=''

export ELMON=cmMvtanld


#? [ -f ~/.bashrc.PS1 ] && source ~/.bashrc.PS1

source ~/bin/transfer.sh 2>/dev/null
