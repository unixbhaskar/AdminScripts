#!/bin/bash

###############################################
# NOTE: in this script, the MAX_DELTA variable
# depends on how often the script is called.
# If it's called every hour, a warning will be
# issued if the log file's size increases by
# MAX_DELTA in an hour. Remember to change MAX_DELTA
# if you change how often the script is called
###############################################

###################
# Script settings
###################
#
DD="/var/apache_scripts_data" # Data directory
EMAIL="root@openSUSE" # E-mail address for warnings
#
LOGS_DIRS="/var/log/apache2/*/"

MAX_GROWTH=500 # Maximum growth in K
MAX_SIZE=16000 # Maximum size in K

for i in $LOGS_DIRS;do

#echo DEBUG: Now analysing $i

# This will make sure that there is
# ALWAYS a number in log_size_last,
# even if $DD/$i/log_size_last doesn't
# exist
#
if [ ! -f $DD/log_size_subdirs/$i/log_size_last ]; then
log_size_last=0
#echo DEBUG: Previous file not found
else

log_size_last='cat $DD/log_size_subdirs/$i/log_size_last'
#echo DEBUG: file found
#echo DEBUG: Last time I checked, the size was $log_size_last

fi

# Find out what the size was last time
# the script was run. The following command
# reads the last field (cut -f 1) of the last
# line (tail -n 1) of the du command. In "du"
# -c gives a total on the last line, and -k
# counts in kilobytes. To test it, run first
# du by itself, and then add tail and cut
#
size='du -ck $i | tail -n 1 | cut -f 1'

# Paranoid trick, so that there is always a number there
#
size='expr $size + 0'

#echo DEBUG: size for $i is $size

# Write the new size onto the log_size_last file
#
mkdir -p $DD/log_size_subdirs/$i
echo $size » $DD/log_size_subdirs/$i/log_size_last

# Find out what the difference is from last
# time the script was run
#
growth='expr $size - $log_size_last'
#echo DEBUG: Difference: $growth

# Check the growth
#
if [ $growth -ge $MAX_GROWTH ];then
echo "
Hello,

The directory $i has grown very quickly ($growth K).
Last time I checked, it was $log_size_last K. Now it is $size K.
You might want to check if everything is OK!

Yours,
log_size_check
" | mail -s "log_size_check: growth warning" $EMAIL

#echo DEBUG: ALARM GROWTH
fi


if [ $size -ge $MAX_SIZE ];then
echo "
Hello,

The directory $i has exceeded its size limit.
Its current size is $size K, which is more than $MAX_SIZE K,
You might want to check if everything is OK!

Yours,
log_size_check

" | mail -s "log_size_check: size warning" $EMAIL

#echo DEBUG: ALARM SIZE
fi

#echo DEBUG: ------------------------
done
