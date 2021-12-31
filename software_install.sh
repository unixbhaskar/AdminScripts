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
calcurse htop lsof feh st dmenu mutt postfix lynx w3m pass  gpg2 curl wget
syslog-ng iptraf-ng moreutils findutils dhcp dhcpcd wpa_supplicant sudo vifm
surf mpv ffmpeg isync cmus cronie imgmagick zip xz psutils xclip xsel xdotool
clipmenu clipmenud telegram tcpdump ipcalc sysstats etckeeper aspell emacs"

source /home/bhaskar/colors.sh

if [[ $UID != 0 ]];then
    echo ${Bright}${Red}"You have to be superuser to run this script.${Normal}"
    exit 1
fi

printf "\n\n\t Installing minimal environment for the productivity on ${Bright}${Cyan}$(echo $OS)${Normal} \n\n"

software_install() {
	printf "Which distro [G/D/S/O/A] : %s"
	read -r distro
	if [[ $distro == "G" ]];then
		gentoo_soft_install
		pull_down_my_settings_from_github
	elif [[ $distro  == "D" ]];then
	        debian_soft_install
		pull_down_my_settings_from_github
	elif [[ $distro == "S" ]];then
		slackware_soft_install
		pull_down_my_settings_from_github
	elif [[ $distro == "O" ]];then
		opensuse_soft_install
		pull_down_my_settings_from_github
	elif [[ $distro == "A" ]];then
		arch_soft_install
		pull_down_my_settings_from_github
	else
		echo Nothing Chosen..aborting!
		exit 1
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


pull_down_my_settings_from_github() {

printf "Getting the ${Bright}${Blue}dotfiles${Normal} from ${Bright}${Magenta}GitHub${Normal}....\n"

git clone --recurse-submodules --remote-submodules git@github.com:unixbhaskar/dotfiles.git
cd dotfiles
cp -v * $HOME/

}

gentoo_soft_install() {

if [[ $(command -v emerge) != "" ]];then
	emerge -vt ${pkgs}
else
	echo ${Bright}${Red}This is not a Gentoo system ${Normal}
	exit 1
fi
}

debian_soft_install() {
if [[ $(command -v apt-get) != "" ]];then
      apt-get install ${pkgs} --yes
else
	echo ${Bright}${Red}This is not a Debian system ${Normal}
	exit 1
fi
}

slackware_soft_install() {
if [[ $(command -v slackpkg) != "" ]];then
	slackpkg install ${pkgs} --yes
else
	echo ${Bright}${Red}This is not a Slackware system ${Normal}
	exit 1
fi
}
opensuse_soft_install() {
if [[ $(command -v zypper) != "" ]];then
        zypper in ${pkgs} --yes
else
	echo ${Bright}${Red}This is not a Opensuse system ${Normal}
	exit 1
fi

}
arch_soft_install() {
if [[ $(command -v pacman) != "" ]];then
	pacman -S ${pkgs} --noconfirm
else
	echo ${Bright}${Red}This is not a Arch linux system ${Normal}
	exit 1
fi
}


software_install
