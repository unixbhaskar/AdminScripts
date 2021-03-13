#!/usr/bin/env bash
# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
if [[ -e /etc/bashrc || -e /etc/bash.bashrc ]]; then

 source /etc/bashrc || source /etc/bash.bashrc

fi

LESSOPEN="|/home/bhaskar/bin/lesspipe.sh %s"; export LESSOPEN
export PATH="$PATH:/home/bhaskar/bin"

#export PILOTRATE=115200
test -s ~/.alias && . ~/.alias || true
export HISTTIMEFORMAT="%h/%d/%Y - %H:%M:%S "
export HISTFILESIZE=99999
export  HISTSIZE=99999
alias ls="ls --color=always"
shopt -s checkwinsize cdspell autocd direxpand dirspell dotglob globstar histappend
alias mount="mount | column -t"
alias ports='netstat -tulanp'
alias meminfo='free -m -l -t'
alias psmemhog='ps auxf | sort -nr -k 4'
alias pscpuhog='ps auxf | sort -nr -k 3'
alias wget='wget -c'
alias rsync='rsync --progress --stats -ravz'
alias c="clear"
alias d='cd ~/Downloads'
alias p='cd ~/Pictures'
alias linuxgit='cd ~/git-linux/linux/'
alias boot='cd /boot'
alias music='cd ~/Music'
alias admscripts='cd ~/Adm_scripts'
alias docu='cd ~/Documents'
alias dstat='dstat -afv'
alias root="sudo su -"
alias sstatus="sudo systemctl status"
alias srestart="sudo systemctl restart"
alias diskinfo="df -h"
alias iptlist='sudo /sbin/iptables -L -n -v --line-numbers'
alias iptlistin='sudo /sbin/iptables -L INPUT -n -v --line-numbers'
alias iptlistout='sudo /sbin/iptables -L OUTPUT -n -v --line-numbers'
alias iptlistfw='sudo /sbin/iptables -L FORWARD -n -v --line-numbers'
alias vpn_start='sudo /home/bhaskar/vpn_connect'
alias dmesg='sudo dmesg -H -T'
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias copy_to='sudo cp -v'
alias week='date +%V'
alias filepath='ls | sed "s:^:`pwd`/:"'
alias abspath='find $PWD -maxdepth 1 | xargs ls -ld'
alias i3config="cd ~/.config/i3"
alias v="vim -u ~/.vimrc"
alias sshot="cd ~/Pictures/Screenshots"
alias github_repo='/home/bhaskar/bin/github_repo'
alias see_log='sudo tail -f /var/log/messages || journalctl -f '
alias gitlog=gitlog
alias dmesg_err='sudo dmesg -H -T -l err'
alias ip='ip --color=auto'
alias journal_clear="sudo journalctl --vacuum-size=50000"
alias shortcut_pages="cd $HOME/shortcut/pages && ls | basename -s .md * | less"
alias githublinux="cd $HOME/git-linux/linux_github_fork"
alias githubgit="cd $HOME/git-linux/git_github_fork"
alias gcl=gclone
alias linuxpull="cd ~/git-linux/linux && git switch master && git pull && cd ~"
alias githubi3="cd $HOME/git-linux/i3"
alias update_buildroot="cd $HOME/git-linux/buildroot && git pull && cd ~"
alias docs-next-update="cd $HOME/git-linux/docs-next && git pull && cd ~"
alias calendar="/usr/local/bin/calcurse -C $HOME/.calcurse"
alias ulb="ls /usr/local/bin"
alias lbin="ls $HOME/bin"
alias h="history"
alias fastping="ping -c 10 -i.2 google.com"
alias kbuild_update="cd $HOME/git-linux/linux-kbuild && git pull && cd ~"
alias kbuild_source="cd $HOME/git-linux/linux-kbuild && tig"
alias docsnext_source="cd $HOME/git-linux/docs-next && tig"
alias buildroot_source="cd $HOME/git-linux/buildroot && tig"
alias linux_source="cd ~/git-linux/linux && tig"
alias linuxnet_source="cd $HOME/git-linux/linux-net && tig"
alias wiki="vim $HOME/vimwiki/index.wiki"
alias notification="$HOME/bin/notification > /dev/null 2>&1"
alias gitconfig="git config --global --edit"
alias vimrc="vim ~/.vimrc"
alias muttrc="vim ~/.muttrc"
alias reload_bashrc="source ~/.bashrc"
alias bashrc="vim ~/.bashrc && source ~/.bashrc"
alias cat="ccat"
alias videodl="$HOME/bin/youtube-dl -f 18 $1"
alias mp3dl="$HOME/bin/youtube_video_to_mp3_conv.sh $1"
alias i3config="vim ~/.ithreeconfig"
alias linux-next="cd $HOME/git-linux/linux-next"
alias profile="vim ~/.profile"
alias i3blocks="vim ~/.ithreeblocksconfig"
alias i3scripts="cd ~/.config/i3/ && ls"
alias scriptsgit="cd ~/git-linux/AdminScripts"
alias lt="cd ~/LaTeX_Workouts"
alias vimplugin=vimplugin
alias archlinux_update="cd $HOME/git-linux/ArchLinux_Kernel && git pull && cd ~"
alias gentoo_update="cd $HOME/git-linux/gentoo && git pull && cd ~"
alias slackware_update="cd ~/git-linux/SlackBuilds && git pull && cd ~"
alias debian_update="cd ~/git-linux/debian_linux && git pull && cd ~"
alias gdb="gdb --tui --quiet --statistics $1"
alias photo="sxiv -t $1"
alias vimpull="cd ~/git-linux/vim && git pull && cd ~"
alias screenrc="vim $HOME/screenrc"
alias vimb_config="vim ~/.config/vimb/config"
alias newsboat_config="vim ~/.newsboat/config"
alias feeds="$(command -v newsboat)"
alias style_vimb="vim ~/.config/vimb/style.css"
alias vim_plugin_list="grep  Plugin ~/.vimrc | grep -v '^\"'"
alias keybinds_i3="grep bindsym ~/.config/i3/config | grep -v ^# | less"
alias mpv="mpv --no-audio-display"
alias menu="dmenufm -d -f -D -F -r $1"
alias vim_plugins_update="v +PluginUpdate +qa"
alias vim_plugins_install="v +PluginInstall +qa"
alias list_dir="ls -ad */"
alias systemd_running_services="command systemctl --no-page --no-legend --plain -t service --state=running"
alias which_arch="getconf LONG_BIT"
alias check_bad_sector="sudo badblocks -n -s -b 2048 $1"
alias aspell="aspell -d \"en_US.multi\" -c $1"
alias pdf_open="$(command -v zathura) $1"
alias mycalstart=mycalservice
alias mycalstatus="systemctl --user status mycal"
alias mycalrestart="systemctl --user restart mycal.timer && systemctl --user restart mycal.service"
alias user_daemon_reload="systemctl --user daemon-reload"
alias daemon_reload="sudo systemctl daemon-reload"
alias user_systemd_dir="cd ~/.local/share/systemd/user/"
alias mailsyncstart=mailsynclocally
alias mailsyncstatus="systemctl --user status mailsync"
alias mailsyncrestart="systemctl --user restart mailsync.timer && systemctl --user restart mailsync.service"
alias list_user_timers="systemctl --user list-timers --all"
alias list_system_timers="systemctl  list-timers --all"
alias keyboard_key_values="xmodmap -pke | less"
alias fix_spell="$HOME/git-linux/linux/scripts/checkpatch.pl -f --terse --nosummary --types=typo_spelling $1"
alias build=build
alias see_portage_log="$(command -v elogv)"
alias localmail="mutt -F $HOME/.muttrc.local"
alias enable_config="scripts/config --enable $1"
alias disable_config="scripts/config --disable $1"
alias who="git blame $1"

unset SSH_ASKPASS
#export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#gpgconf --launch gpg-agent

#man page color
#export LESS_TERMCAP_mb=$'\E[01;31m'

#Gitlog

gitlog() {
  if [ "$1" ] && [ "$2" ]; then
  git log --pretty=format:"%h%x09 %C(cyan)%an%x09 %Creset%ad%x09 %Cgreen%s" --date-order -n "$1" --author="$2"
 elif [ "$1" ]; then
   git log --pretty=format:"%h%x09 %C(cyan)%an%x09 %Creset%ad%x09 %Cgreen%s" --date-order -n "$1"
 else
    git log --pretty=format:"%h%x09 %C(cyan)%an%x09 %Creset%ad%x09 %Cgreen%s" --date-order
  fi
 }

# configure,make and make install combine in build call

build() {

	tm="/usr/bin/time -f"


	echo "Start the building .... $(date +'%T') on host $(uname -n)"
        echo

	if [  -f configure ]  && [  -x configure ]; then

            ${tm} "\n\n\tElapsed Time : %E \n\n" $PWD/configure

	fi

	if [ $? == 0 ]; then

             ${tm} "\n\n\tElapsed Time : %E \n\n" make -j4

	fi

	if [ $? == 0 ]; then

           ${tm} "\n\n\tElapsed Time : %E \n\n" sudo make install

          echo "Done"
     fi

}





#Git grep as search in repo

search() {
	if [ $# -ne 1 ]; then

		echo "You need to pass the search string"

	elif [ ! -e .git ];then

		sudo find / -name "$1" -ls  2> /dev/null

	else
		git grep -n "$1"
	fi
}


#git clone and get into the cloned directory

gclone() {

	 cd $HOME/git-linux && git clone "$1" &&  cd "$(basename $1 .git)"
}


# To clone vim plugin ~/.vim/bundle  dir

vimplugin() {
	 cd $HOME/.vim/bundle && git clone "$1" &&  cd "$(basename $1 .git)"
 }


# To kick of my calendar notification in systemd driven os

mycalservice() {
	init_system=$(/home/bhaskar/bin/find_init)
	if [[ $init_system  == "SYSTEMD" ]] && [[ $(pgrep X) != "" ]];then
	systemctl --user start mycal.timer
	systemctl --user start mycal.service
fi
}

# To start mail sync program aka mbsync

mailsynclocally() {
	init_system=$(/home/bhaskar/bin/find_init)
	if [[ $init_system  == "SYSTEMD" ]] && [[ $(pgrep X) != "" ]];then
	systemctl --user start  mailsync.timer
	systemctl --user start  mailsync.service
fi
}


# Wrap the following commands for interactive use to avoid accidental file overwrites.
rm() { command rm -i "${@}"; }
cp() { command cp -i "${@}"; }
mv() { command mv -i "${@}"; }



#Intialize the terminal for gpg

GPG_TTY=$(tty)
export GPG_TTY
export PINENTRY_USER_DATA=USE_CURSES=1

# Change the terminal prompt to git mode, very show but useful

GIT_PROMPT_ONLY_IN_REPO=1
source ~/.bash-git-prompt/gitprompt.sh
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1


#create directory and enter into it

mkd() {
	mkdir -p "$@" && cd "$_";
}

#To show apt-history

function apt-history(){

      case "$1" in
        install)
              grep 'install ' /var/log/dpkg.log
              ;;
        upgrade|remove)
              grep $1 /var/log/dpkg.log
              ;;
        rollback)
              grep upgrade /var/log/dpkg.log | grep "$2" -A10000000 | grep "$3" -B10000000 | gawk '{print $4"="$5}'
              ;;
        *)
              cat /var/log/dpkg.log
              ;;
      esac
}




export TERM=st-256color
export EDITOR=vim
export BROWSER="vimb"


#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#Open/copy/to_gitrepo files with the help fzf and vim

file_open() { vim "$(find  $(pwd) -type f | fzf)"  ;}
backup_dot_files() { cp -v "$1" "$(find /data/dotfiles -name '*' -type f | fzf)" ;}
copy_to_gitrepo() { cp -v "$1" "$(find ~/git-linux/AdminScripts -name '*'  -type f | fzf)" ;}

#Gentoo specific stuff

alias eqf='equery f' #list all files installed by PKG
alias equ='equery u' #display USE flags for PKG
alias eqh='equery h' #list all packages that have USE flag
alias eqa='equery a' #list all packages for matching ENVIRONMENT data stored in /var/db/pkg
alias eqb='equery b' #list what package FILES belong to
alias eql='equery l' #list package matching PKG
alias eqd='equery d' #list all packages directly depending on ATOM
alias eqg='equery g' #display a tree of all dependencies for PKG
alias eqc='equery c' #list changelog entries for ATOM
alias eqk='equery k' #verify checksums and timestamps for PKG
alias eqm='equery m' #display metadata about PKG
alias eqy='equery y' #display keywords for specified PKG
alias eqs='equery s' #display total size of all files owned by PKG
alias eqw='equery w' #print full path to ebuild for PKG

#Shortcut to common kernel tool

alias owner="scripts/get_maintainer.pl $1"

last_commited_hash() {

      latest_hashval="$(gitlog | gawk '{ print $1 }' | head -1)"

      # echo This is the last committed hash : $latest_hashval

      echo $latest_hashval
}


checkpatch() {

	patch_check="scripts/checkpatch.pl -g $(gitlog | gawk '{ print $1 }' | head -1)"

	$patch_check
}
filehash() {

	git ls-files -z  | GIT_PAGER= xargs -0 -L1 -I '{}' git log -n 1 --format="%h {}" -- '{}'

}

#Sane way to do sed

sedwise() {

        if [[ $# -ne 2 ]];then

		echo Use like this: sedwise regexex filename
	else

		sed -i.$(date +'%F') $1 $2

		echo The original file is stored as $1.$(date +'%F')
	fi
	}

# Compare two files side by side

changes() {

	if [ -e .git ];then

		git difftool

	elif [ $# -ne 2 ];then

		printf "You need to provide both the file names \n"
	else
		$(command -v vimdiff) $1 $2
	fi
}

discard_changes() {

        if [[ $# -ne 1 ]];then

		printf "You need to provide the file name \n"

	else

		git checkout -- $1

	fi
}

get_email_addresses() {

        filename=$1
	scripts/get_maintainer.pl  $filename | tee $filename.$(date +'%T') 1> /dev/null
	extract_email_address $filename.* | paste -s -d, - > email_list
	rm -f $filename.*
}


send_patch() {
	git format-patch -1
	patchfile=$(basename *.patch)
	to="--to=$(cat email_list)"
	cc="--cc=rdunlap@infradead.org,linux-kernel@vger.kernel.org"
	an="--annotate"

	      printf "Checking values before sending the patch ....\n"
	      printf "\n ${patchfile}  ${to}  ${cc}\n"

	      printf "Is it look alright?? [Y/N] : %s"
	      read consent

         if [[ "$consent" == "N" ]];then
	      printf "\n\n  Patchfile,TO and CC field must be filled, it seems values are missing..so,aborting.\n"
         else
	      git send-email $patchfile ${to} ${cc} ${an}

	      printf "\nGetting rid of temp files....\n"
	      rm -f email_list
	      rm -f *.patch
	  fi
  }
