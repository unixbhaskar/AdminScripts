#!/usr/bin/env bash

source /home/bhaskar/colors.sh
NOCOLOR="\033[0m"

printf "\n\n\n ${Reverse}${Bright}${LimeYellow} Get the latest firefox from Mozilla ${NOCOLOR} ....\n\n\n"

curl -Lo firefox.tar.bz2 'https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US'

if [[ $? == 0 ]];then
  printf "${Bright}${Green} Success ${NOCOLOR} \n\n"
else
  printf "${Bright}${Red} Failed ${NOCOLOR} \n\n"
fi

arch=$(uname -m)

if [[ "$arch" == "x86_64" ]];then
mv -v $HOME/firefox $HOME/firefox.$(date +"%d-%m-%Y")
fi      

tar -xjf firefox.tar.bz2

cd firefox

./firefox --version

cd ..

rm -f firefox.tar.bz2

#printf "${Bright}${Yellow} Take necessary measure to install the new one. ${NOCOLOR} ... \n\n"
#version=$(firefox --version | gawk '{ printf $3 }')

#mv -v firefox firefox_$version

printf "${Bright}${Magenta} Kill the existing one and start manually the updated version ${NOCOLOR}...\n\n"

pkill firefox    

printf "Clearing the startup cache ..wait \n\n"

find ~/.cache/mozilla/firefox -type d -name startupCache | xargs rm -rf 
printf "\n\n Done \n"

whereis firefox 

#printf "\n\n Put the old binary file to remove : %s "
#read old_binary
# rm -f $old_binary

printf "\n\n Put the old directory too for removal : %s "
read old_dir
rm -rf $old_dir

exit 0
