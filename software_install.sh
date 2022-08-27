#!/bin/bash -
#===============================================================================
#
#          FILE: software_install.sh
#
#         USAGE: ./software_install_.sh
#
#   DESCRIPTION: This script will fetch and build software on freshly install
#                system
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: Set up for minimal productivity environment
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 02/08/2021 20:31
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

pkgs="i3 i3block i3lock vim scrot zathura screen git newsboat
calcurse htop lsof feh  mutt postfix lynx w3m pass gpg2 curl wget
syslog-ng iptraf-ng moreutils findutils dhcp dhcpcd wpa_supplicant sudo
mpv ffmpeg isync cmus cronie imgmagick zip xz psutils xclip xsel xdotool
clipmenu clipmenud tcpdump ipcalc sysstats etckeeper aspell emacs"


if [[ $UID != 0 ]];then
    echo "You have to be superuser to run this script."
    exit 1
fi

printf "\n\n\t Installing minimal environment for the productivity on $hostname.... \n\n"

software_install() {
	printf "Which distro [G/D/S/A] : %s"
	read -r distro
	if [[ $distro == "G" ]];then
		install_on_gento
		pull_down_my_settings_from_github
	elif [[ $distro  == "D" ]];then
	        install_on_debian
		pull_down_my_settings_from_github
	elif [[ $distro == "S" ]];then
		install_on_slackware
		pull_down_my_settings_from_github
	elif [[ $distro == "A" ]];then
		install_on_arch
		pull_down_my_settings_from_github
	else
		echo Nothing Chosen..aborting!
		exit 1
	fi
}

# Dotfiles
pull_down_my_settings_from_github() {

printf "Getting the dotfiles from GitHub....\n"

git clone --recurse-submodules --remote-submodules git@github.com:unixbhaskar/dotfiles.git
cd dotfiles
cp -v * $HOME/

}

# Fetch st from my github repo

fetch_st() {
  git clone git@github.com:unixbhaskar/st_terminal_build
  cp st_terminal_build/st_sol $HOME/bin/
  cp st_terminal_build/st_gruvbox $HOME/bin/
}

# Fetch vimb from github

fetch_vimb() {
  git clone git@github.com:unixbhaskar/vimb_build
  cp vimb_build/vimb $HOME/bin/
}

# Fetch dmenu from github

fetch_dmenu() {
  git clone git@github.com:unixbhaskar/dmenu_build
  cp dmenu_build/dmenu $HOME/bin/
  cp dmenu_build/dmenu_run $HOME/bin/
  cp dmenu_build/dmenu_path $HOME/bin/
}

install_on_gentoo() {

if [[ $(command -v emerge) != "" ]];then
	emerge -vt ${pkgs}
else
	echo This is not a Gentoo system
	exit 1
fi
}

install_on_debian() {
if [[ $(command -v apt-get) != "" ]];then
      apt-get install ${pkgs} --yes
else
	echo This is not a Debian system
	exit 1
fi
}

install_on_slackware() {
if [[ $(command -v slackpkg) != "" ]];then
	slackpkg install ${pkgs} --yes
else
	echo This is not a Slackware system
	exit 1
fi
}


install_on_arch() {
if [[ $(command -v pacman) != "" ]];then
	pacman -S ${pkgs} --noconfirm
else
	echo This is not a Arch linux system
	exit 1
fi
}


software_install
