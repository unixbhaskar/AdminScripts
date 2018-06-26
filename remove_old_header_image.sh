#!/bin/bash

printf "Enlisting and removing stale stuff from the system to aquire space ...\n\n\n"


dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | tee stale  

for i in `cat stale` 
do echo $i 
sleep 3	
apt-get purge $i
done

exit 0

