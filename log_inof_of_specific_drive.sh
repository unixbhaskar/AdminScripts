#!/bin/bash

partition="/dev/sda1 /dev/sda3 /dev/sda4 /dev/sda5"

free_space=`df -h | grep $partition | cut -b 41-50`
echo $free_space

if [ "$free_space" <= 5000 ]
then
 message="WARNING: Only $free_space blocks left on $partition";
 logger -p local0.crit $message
# echo $message | mail -s "Partition problem" root@bhaskar-laptop
fi
