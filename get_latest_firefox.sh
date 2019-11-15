#!/bin/bash - 
#===============================================================================
#
#          FILE: get_latest_firefox.sh
# 
#         USAGE: ./get_latest_firefox.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: curl tar 
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 09/24/2019 15:27
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
source $HOME/colors.sh
NOCOLOR="\033[0m"

printf "\n\n\n ${Reverse}${Bright}${LimeYellow} Get the latest firefox from Mozilla ${NOCOLOR} ....\n\n\n"

curl -Lo firefox.tar.bz2 'https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US'

if [[ $? == 0 ]];then
	  printf "${Bright}${Green} Success ${NOCOLOR} \n\n"
  else
	    printf "${Bright}${Red} Failed ${NOCOLOR} \n\n"
fi

current_date=$(date '+%F')
folder_date=$(ls -ld --full-time $HOME/firefox | gawk '{ print $6 }')

if [[ "$folder_date" -ne "$current_date" ]];then
	mv -v $HOME/firefox $HOME/firefox.$(date +"%d-%m-%Y")
fi

tar -xjf firefox.tar.bz2

cd firefox
  $HOME/firefox/firefox firefox_$version
 cp  $HOME/firefox/firefox $HOME/bin/firefox

 printf "${Bright}${Magenta} Kill the existing process.... ${NOCOLOR}...\n\n"

 pkill firefox

 printf "Clearing the startup cache ..wait \n\n"

 find ~/.cache/mozilla/firefox -type d -name startupCache | xargs rm -rf
 printf "\n\n Done \n"

cd ..
rm -f firefox.tar.bz2
# whereis firefox

# printf "\n\n Put the old binary file to remove : %s "
#  read old_binary
#   rm -f $old_binary

# printf "\n\n Put the old directory too for removal : %s "
# read old_dir
# rm -rf $old_dir

#start up 

firefox&

exit 0
