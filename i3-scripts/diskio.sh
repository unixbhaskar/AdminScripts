#!/usr/bin/env bash  
#===============================================================================
#
#          FILE: disk.sh
# 
#         USAGE: ./disk.sh 
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

show=$(sar -D | grep Average | gawk '{ print "%user:"$3"-" "%system:"$5"-""%idle:"$8 }')

echo $show
