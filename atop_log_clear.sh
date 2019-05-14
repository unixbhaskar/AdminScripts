#!/usr/bin/env bash  
#===============================================================================
#
#          FILE: atop_log_clear.sh

#         USAGE: ./atop_log_clear.sh 
# 
#   DESCRIPTION:Stop filling the disk by empty the file 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: --- system maintenance
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 05/14/2019 12:08
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
DIR=/var/cache/atop.d/
size=$(du -shc /var/cache/atop.d | gawk '{ print $1 }' | tr -d "M|G")  

if [[ "$size" != "100" ]]; then
  #echo "It's filing up the disk,so emptying out.."
  cd $DIR 

  >atop.acct

fi



