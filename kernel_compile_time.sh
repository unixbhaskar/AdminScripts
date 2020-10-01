#!/bin/bash  
#===============================================================================
#
#          FILE: kernel_compile_time.sh
# 
#         USAGE: ./kernel_compile_time.sh 
# 
#   DESCRIPTION: Show, how much time kernel compile takes.
# 
#       OPTIONS: ---
#  REQUIREMENTS: Run this script in a for do loop 
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 08/16/2019 18:13
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
#start_process=$(date +'%T')
pid=$($HOME/Adm_scripts/process_elapsed_time | pgrep kernel_update | gawk '{ print $1 }' | head -1) 
elapsed_time=$($HOME/Adm_scripts/process_elapsed_time | grep kernel_update | gawk '{ print "Elapsed Time:"  $8 }' | head -1)
process_time=$(echo "PID:" $pid $elapsed_time)
#duration=$("$elapsed_time" - "$start_process" | bc)
#echo $process_time  

if [[ $pid -eq 0 ]] ;then 

	trap EXIT
fi
#while true;
#do
/usr/bin/notify-send --expire-time=60000 --urgency=normal "The kernel has been compiling for..." "$process_time"
#sleep 20
#done

