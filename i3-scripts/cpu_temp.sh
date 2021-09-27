#!/bin/bash - 
#===============================================================================
#
#          FILE: cpu_temp.sh
# 
#         USAGE: ./cpu_temp.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 05/29/2019 18:28
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
t_warn=${1:-60}
t_crit=${2:-75}
# sorting temp values for all cores
t_curr=($(sensors -u coretemp-isa-0000 | awk '/input/{ printf "%d\n", $2}' | sort))
# using last value of array -> max temp ${t_curr[3]}
if [[ $t_curr -lt $t_warn ]]
then color="#90A959" #green - base16
elif [[ $t_curr -ge $t_warn ]] && [[ $t_curr -lt $t_crit ]]
then color="#D28445" #orange - base16
else color="#AC4142" #red - base16
fi
# elements output for JSON (short text, full text, color)
echo "$t_curr"
echo "$t_curr"
echo "$color"
exit
