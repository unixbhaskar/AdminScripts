#!/bin/bash

#This script can be improved leaps and bound,I did it for my convenience, a dirty way
#Because I am aware of few things so I hardcoded it (bad thing),should be autometically discovered those

printf " Finding out how many kernels installed in the system ...\n\n\n"


num=`dpkg --list | grep linux-image | grep ii | wc -l`

if [[ $num > 2 ]]; then

 printf "Time to strip off those older kernels \n\n\n"

else 
 printf " Looks alright to me :) \n\n\n"

fi

printf "Lets remove the stale kernels..... \n\n\n"

# Damn, the number greping should be done in much better way , and the reverse one too...heck..in a hurry do all sort of nonsense..

dpkg --get-selections | grep linux-image | grep 4.15 |  sed s/install//g | uniq -u |  grep -v 10  | tee kernel_holds
 
for kernels in `cat kernel_holds`
do
   echo $kenrels

   apt-get --purge remove $kernels -y
done

exit 0


