#!/bin/bash
###################
# Script settings
###################
DD="/var/data" # Data directory
EMAIL="root@bhaskar-laptop.localdomain" # Email address for warnings
MAX_LOAD="0.90" # Maximum accepted load
ALARM_EVERY="60" # Will send an email every ALARM_EVERY minutes

# Convert ALARM_EVERY into seconds
#
ALARM_EVERY_S=$(expr $ALARM_EVERY \* 60)

#echo DEBUG: ------------------------
#echo DEBUG: CPU_load running now...

# This file exists, a warning was given
# when running this program
#
if [[ -f $DD/CPU_load_lock ]];then
#echo DEBUG: CPU_load_lock exists

# Get the current time, and the time when the script
# ran last. Remember that "time" here is the
# number of seconds since 1/1/1970
#
current_time=$(date '+%s')
last_run_time=$(cat $DD/CPU_load_lock)

# Paranoia. Make sure that $current_time
# and $last_run_time are not empty strings (the rest
# of the script wouldn't like it)
#
current_time=$(expr $current_time + 0)
last_run_time=$(expr $last_run_time + 0)

# "gap" is how many seconds passed since
# the script was last executed
#
gap=$(expr $current_time - $last_run_time)

#echo DEBUG: current_time : $current_time
#echo DEBUG: last_run_time: $last_run_time
#echo DEBUG: gap: $gap \(ALARM_EVERY_S is $ALARM_EVERY_S\)

# If enough seconds have passed since creating
# CPU_load_lock, delete the file
#
if [[ $gap -ge $ALARM_EVERY_S ]];then
#echo DEBUG: Enough time has passed, deleting lock...
rm -f $DD/CPU_load_lock
elif
#echo DEBUG: not enough seconds have passed, exiting...
exit

# Get the system's average load valuees. PLEASE NOTE
# that this will only work on Linux. You will need
# to find out how to get these values
# on your system!
#
loadavg=$(cat /proc/loadavg)
one=$(echo $loadavg | cut -d " " -f 1)
two=$(echo $loadavg | cut -d " " -f 2)
three=$(echo $loadavg | cut -d " " -f 3)
#echo DEBUG: $loadavg -- $one -- $two -- $three

# You can't use expr, because the load info is
# a floating point number (0.15). So, you are
# passing a string like "0.10 » 0.15" to bc's
# standard input. bc will print "0" (false) or
# "1" (true).
#
one_big=$(echo $one \» $MAX_LOAD | bc)
two_big=$(echo $two \» $MAX_LOAD | bc)
three_big=$(echo $three \» $MAX_LOAD | bc)
#echo DEBUG: $one_big -- $two_big -- $three_big

# If any of the averages are too high, send a
# warning email
#
if [ "$one_big" = "1" -o "$two_big" = "1" -o "$three_big" = "1" ];then

#echo DEBUG: ALARM LOAD
echo "
Hello,

The system load is higher than the set limit. The values are:

$loadavg

You may need to do something about it. There will be no warnings
for $ALARM_EVERY minutes.

Yours,
CPU_load

" | mail -s "CPU_load: warning" $EMAIL

# This will prevent further messages
# being sent for a while
#
date '+%s' »$DD/CPU_load_lock

fi
