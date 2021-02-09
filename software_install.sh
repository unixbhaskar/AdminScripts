#!/bin/bash -
#===============================================================================
#
#          FILE: software_install.sh
#
#         USAGE: ./software_install_.sh
#
#   DESCRIPTION:
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
OS=$(uname -n)
pkgs="i3 i3block i3lock vim scrot vimb zathura screen git neofetch newsboat
calcurse htop lsof feh st dmenu mutt postfix lynx w3m pass gpg gpg2 curl wget
syslog-ng iptraf-ng moreutils findutils dhcp dhcpcd wpa_supplicant sudo vifm
surf mpv ffmpeg isync cmus cronie imgmagick zip xz psutils xclip xsel xdotool
clipmenu clipmenud telegram tcpdump ipcalc sysstats etckeeper"

if [[ $UID != 0 ]];then
    echo "You have to be superuser to run this script."
    exit 1
fi

printf "\n\n\t Installing minimal environment for the productivity on  $(echo $OS) \n\n"

software_install() {
	printf "Which distro [G/D/S/O/A] : %s"
	read distro
	if [[ $distro == "G" ]];then
		gentoo_soft_install
	elif [[ $distro  == "D" ]];then
	        debian_soft_install
	elif [[ $distro == "S" ]];then
		slackware_soft_install
	elif [[ $distro == "O" ]];then
		opensuse_soft_install
	elif [[ $distro == "A" ]];then
		arch_soft_install
	fi
}
# declare -A osInfo;
# osInfo[/etc/arch-release]="pacman -S --yes"
# osInfo[/etc/gentoo-release]="emerge -vt"
# osInfo[/etc/SuSE-release]="zypper --yes install"
# osInfo[/etc/debian_version]="apt-get --yes install"
# osInfo[/etc/slackware_version]="slackpkg --yes install"
# for f in ${!osInfo[@]}
# do
#     if [[ -f $f ]];then
#         echo Package manager: ${osInfo[$f]}
#     fi
# done



gentoo_soft_install() {

if [[ $(command -v emerge) != "" ]];then
	emerge -vt ${pkgs}
else
	echo This is not a Gentoo system
	exit 1
fi
}

debian_soft_install() {
if [[ $(command -v apt-get) != "" ]];then
      apt-get install ${pkgs} --yes
else
	echo This is not a Debian system
	exit 1
fi
}

slackware_soft_install() {
if [[ $(command -v slackpkg) != "" ]];then
	slackpkg install ${pkgs} --yes
else
	echo This is not a Slackware system
	exit 1
fi
}
opensuse_soft_install() {
if [[ $(command -v zypper) != "" ]];then
        zypper in ${pkgs} --yes
else
	echo This is not a Opensuse system
	exit 1
fi

}
arch_soft_install() {
if [[ $(command -v pacman) != "" ]];then
	pacman -S ${pkgs} --noconfirm
else
	echo This is not a Arch linux system
	exit 1
fi
}


software_install
