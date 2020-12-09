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
alias movies='cd ~/Movies'
alias githome='cd ~/git-linux'
alias boot='cd /boot'
alias movies2='cd /data/Movies2'
alias videos='cd ~/Videos'
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
alias check_vpn='$HOME/bin/check_vpn_conn.sh'
alias dmesg='sudo dmesg -H -T'
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias copy_to='sudo cp -v'
alias week='date +%V'
alias filepath='ls | sed "s:^:`pwd`/:"'
alias abspath='find $PWD -maxdepth 1 | xargs ls -ld'
alias i3config="cd ~/.config/i3"
alias v="vim -u ~/.vimrc"
alias unbuffer='unbuffer '
alias sshot="cd ~/Pictures/Screenshots"
alias github_repo='/home/bhaskar/bin/github_repo'
alias see_log='sudo tail -f /var/log/messages || journalctl -f '
alias gitlog=gitlog
alias firefox_log='less /data/firefox_log/firefox.log-main.*'
alias dmesg_err='sudo dmesg -H -T -l err'
alias ip='ip --color=auto'
alias journal_clear="sudo journalctl --vacuum-size=50000"
alias shortcut_pages="cd $HOME/shortcut/pages && ls | basename -s .md * | less"
alias githublinux="cd $HOME/git-linux/linux_github_fork"
alias githubgit="cd $HOME/git-linux/git_github_fork"
alias gcl=gclone
alias linuxpull="cd /data/linux && git pull && cd ~"
alias githubi3="cd $HOME/git-linux/i3"
alias update_buildroot="cd $HOME/git-linux/buildroot && git pull && cd ~"
alias docs-next-update="cd $HOME/git-linux/docs-next && git pull && cd ~"
alias calendar="/usr/local/bin/calcurse -C $HOME/.calcurse"
alias ulb="ls /usr/local/bin"
alias lbin="ls $HOME/bin"
alias h="history"
alias fastping="ping -c 10 -i.2 google.com"
alias kbuild_update="cd $HOME/git-linux/linux-kbuild && git pull && cd ~"
alias b4="$HOME/git-linux/b4/b4.sh"
alias update_linuxnet="cd $HOME/git-linux/linux-net && git pull && cd ~"
alias kbuild_source="cd $HOME/git-linux/linux-kbuild && tig"
alias docsnext_source="cd $HOME/git-linux/docs-next && tig"
alias buildroot_source="cd $HOME/git-linux/buildroot && tig"
alias linux_source="cd /data/linux && tig"
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
alias style_vimb="vim ~/.config/vimb/style.css"
alias vim_plugin_list="grep  Plugin ~/.vimrc | grep -v '^\"'"
alias keybinds_i3="grep bindsym .config/i3/config | grep -v ^# | less"
alias mpv="mpv --no-audio-display"
alias menu="dmenufm -d -f -D -F -r $1"
alias vim_plugins_update="v +PluginUpdate +qa"
alias vim_plugins_install="v +PluginInstall +qa"
alias list_dir="ls -ad */"
alias systemd_running_services="command systemctl --no-page --no-legend --plain -t service --state=running"
alias which_arch="getconf LONG_BIT"
alias check_bad_sector="sudo badblocks -n -s -b 2048 $1"
alias aspell="aspell -d \"en_US.multi\" -c $1"
#alias color_values="for i in {0..255}; do echo -e \"\e[38;05;${i}m${i}\"; done | column -c 80 -s \' \'; echo -e \"\e[m"
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
unset SSH_ASKPASS

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

#Git grep as search in repo

search() {
	if [ $# -ne 1 ]; then
		echo "You need to pass the search string"
	else

		git grep "$1" "$(pwd)"
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
	systemctl --user mycal.timer
	systemctl --user mycal.service
fi
}

# To start mail sync program aka mbsync

mailsynclocally() {
	init_system=$(/home/bhaskar/bin/find_init)
	if [[ $init_system  == "SYSTEMD" ]] && [[ $(pgrep X) != "" ]];then
	systemctl --user mailsync.timer
	systemctl --user mailsync.service
fi
}

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




export TERM=screen-256color
export EDITOR=vim
BROWSER="$HOME/bin/vimb"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#Open/copy/to_gitrepo files with the help fzf and vim

of() { vim "$(find  $(pwd) -type f | fzf)"  ;}
backup_dot_files() { cp -v "$1" "$(find /data/dotfiles -name '*' -type f | fzf)" ;}
copy_to_gitrepo() { cp -v "$1" "$(find ~/git-linux/AdminScripts -name '*'  -type f | fzf)" ;}

#Powerline shell prompt

#function _update_ps1() {
#     PS1=$(powerline-shell $?)
# }

# if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
#     PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
# fi

