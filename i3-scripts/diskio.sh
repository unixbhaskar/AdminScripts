#!/usr/bin/env bash
#===============================================================================
#
#          FILE: diskio.sh
#
#         USAGE: ./diskio.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: sysstat package
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 05/12/2019 20:38
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

root=$(mount|grep ' / '|cut -d' ' -f 1)
disk=$(basename $root)
#root=$(readlink /dev/root)
show=$(iostat -p sda | grep $disk  | gawk '{ print "Disk:"$1 ",Read:"$6 ",Write:" $7}')
#show1=$(iostat -p sda | grep $root1 | gawk '{ print "Disk:"$1 ",Read:"$5 ",Write:" $6}')

#if [[ $root != "" ]];then
echo -e "<span color='black' bgcolor='#008B8B'>:$show</span>\n"
#echo $show
#fi

#if [[ $root1 != "" ]];then
#	echo $show1
#fi



