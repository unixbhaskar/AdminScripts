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

#root1=$(mount|grep ' / '|cut -d' ' -f 1)
root=$(readlink /dev/root)
show=$(iostat -p sda | grep $root | gawk '{ print "Disk:"$1 ",Read:"$5 ",Write:" $6}')

echo $show
