#!/bin/bash

###############################################################################################################################
#This script might be a guideline for other managable scripts too.This script written to get an alert about Apache/Httpd daemon.
#Author : Bhaskar Chowdhury
#Date : 12-12-2010
################################################################################################################################

#
SCRIPT_DATA="/var/apache_scripts_data" # Data directory

EMAIL="unixbhaskar@gmail.com" # Email address for warnings
#
ALARM_EVERY="30" # Will send an email every ALARM_EVERY minutes

# Convert ALARM_EVERY into seconds
#
ALARM_EVERY_S=`expr $ALARM_EVERY \* 60`

#echo DEBUG: ---------------------------
#echo DEBUG: apache_alive RUNNING NOW...

# This file exists
#
if [[ -f $SCRIPT_DATA/apache_alive_locked ]]
then
#echo DEBUG: apache_alive_locked exists

# Get the current time, and the time when the script
# ran last. Remember that "time" here is the
# number of seconds since 1/1/1970
#
current_time=`date '+%s'`
last_run_time=`cat $SCRIPT_DATA/apache_alive_locked`

# Paranoia
#
current_time=`expr $current_time + 0`
last_run_time=`expr $last_run_time + 0`

# "gap" is how many seconds passed since
# the script was last executed
#
gap=`expr $current_time - $last_run_time`

#echo DEBUG: current_time : $current_time
#echo DEBUG: last_run_time: $last_run_time
#echo DEBUG: gap: $gap \(ALARM_EVERY_S is $ALARM_EVERY_S\)

# If enough seconds have passed since creating
# CPU_load_lock, delete the file
#
if [[ $gap -ge $ALARM_EVERY_S ]]
then
#echo DEBUG: Enough time has passed, deleting lock...
rm -f $SCRIPT_DATA/apache_alive_locked
else
#echo DEBUG: not enough seconds have passed, exiting...
exit
fi

fi

# Find out if Apache is alive. You might want to
# change the following commands into something
# more meaningful, as they only check whether
# Apache is listening to port 80.
#
alive=`netstat --numeric-ports -l | grep 80`

# If Apache is dead, send a warning email!
#
if [[ "$alive" = "nothing" ]]
then

#echo DEBUG: APACHE IS DEAD
echo "
Hello,

Your Apache/Httpd seems to be dead.

You may need to do something about it. There will be no warnings
for $ALARM_EVERY minutes.

Yours,
Infra Management Team

" | mail -s "apache/httpd_alive: warning" $EMAIL

# This will prevent further messages
# being sent for a while
#
date '+%s' >>$SCRIPT_DATA/apache_alive_locked

#/sbin/service apcahe2 start
fi
