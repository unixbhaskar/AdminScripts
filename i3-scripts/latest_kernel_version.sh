#!/usr/bin/env bash
#===============================================================================
#
#          FILE: latest_kernel_version.sh
#
#         USAGE: ./latest_kernel_version.sh
#
#   DESCRIPTION: Fetch latest stable kernel version
#
#       OPTIONS: ---
#  REQUIREMENTS: ---curl grep
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 05/14/2019 15:41
#      REVISION:  ---
#===============================================================================
set -o nounset                              # Treat unset variables as an error
 # case $BLOCK_BUTTON in
 #        1) notify-send "Kernel Versions:
 #        ~/.config/i3/kernel_feed.sh";;
# esac
new_kernel=$(curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)' | grep 5.14)

installed_kernel_version=$(uname -r | tr -d "-" | tr -d "ArchLinux|debian|Gentoo|Slackware|OpenSuse")


#kernel_version=$(curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)' | grep 5.8)

#kernel_version2=$(curl -s https://www.kernel.org/ | grep -A1 'mainline:' | grep -oP '(?<=strong>).*(?=</strong.*)')
#while :

#do
#echo  "$kernel_version"
#sleep 30
#echo "Mainline_Kernel:$kernel_version2"
#done
echo -e "<span color='black' bgcolor='#FFD700'>:$new_kernel</span>\n"
#echo $new_kernel

if [[ $new_kernel != $installed_kernel_version ]];then

	        /usr/bin/notify-send --expire-time=5000  --urgency=critical
		"There is new kernel available,please install it." "New Kernel: $new_kernel"

fi


