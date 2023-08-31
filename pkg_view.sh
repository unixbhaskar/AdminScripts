#!/usr/bin/env bash
#===============================================================================
#
#          FILE: pkg_view.sh
#
#         USAGE: ./pkg_view.sh
#
#   DESCRIPTION: Show package preview with Fzf ,irrespective of OS.
#
#       OPTIONS: ---
#  REQUIREMENTS: Fzf
#          BUGS: ---
#         NOTES: Convenience for seeing packages in the system.
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 09/01/2023 04:33
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error


if [[ $UID -ne 0 ]];then
	echo Nope,you are suppose to have superuser privilege.
	exit 1
fi


package_browse() {
	if [[ $(uname -n) == "Gentoo" ]];then
	 gentoo_package_browse
       elif [[ $(uname -n) == "debian" ]];then
	debian_package_browse
       elif [[ $(uname -n) == "Slackware" ]];then
	slackware_package_browse
       elif [[ $(uname -n) == "ArchLinux" ]];then
	archlinux_package_browse
else
        echo
fi
}

archlinux_package_browse() {
pacman -Qq | fzf --preview 'pacman -Qil {}' --layout=reverse --bind 'enter:execute(pacman -Qil {} | less)'
}


gentoo_package_browse(){
eix -c --pure-packages | grep I | grep -v N | gawk '{ print $2  }' | fzf --preview='eix -F {}' --layout=reverse
}


slackware_package_browse(){
basedir=/var/lib/pkgtools/packages/

cd "$basedir" || exit 1
sudo su -
ls | gawk '{print $1 }' | fzf --preview='slackpkg info {}' --layout=reverse
}

package_browse