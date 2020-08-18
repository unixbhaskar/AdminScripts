
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
alias v='cd ~/Videos'
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
alias vim="vim -u ~/.vimrc"
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
alias githublinux="cd $HOME/linux/linux_github_fork"
alias githubgit="cd $HOME/git-linux/git_github_fork"
alias gcl="cd $HOME/git-linux/ && git clone $1"
alias linuxpull="cd /data/linux && git pull && cd ~"
alias githubi3="cd $HOME/git-linux/i3"
alias update_buildroot="cd $HOME/git-linux/buildroot && git pull && cd ~"
alias docs-next-update="cd $HOME/git-linux/docs-next && git pull && cd ~"
alias schedule="calcurse -C $HOME/.calcurse"
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
unset SSH_ASKPASS


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



GPG_TTY=$(tty)
export GPG_TTY
export PINENTRY_USER_DATA=USE_CURSES=1

GIT_PROMPT_ONLY_IN_REPO=1
source ~/.bash-git-prompt/gitprompt.sh
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1


#create directory and enter into it
function mkd() {
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
