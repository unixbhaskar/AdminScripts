#!/usr/bin/env bash

#/usr/bin/i3status -c $HOME/.config/i3/i3status.conf | while :


#do
 #   read line
    #RAM=`free -kh | grep Mem | awk '{print $3}'`
    #TOTR=$(cat /proc/meminfo | grep MemT | sed 's/.*\://g' | sed 's/ *//g' | sed 's/kB//g')
    #TOT=$(octave --eval "$TOTR/1024^2" | sed 's/ans = *//g' | sed 's/$/G/g' )

    # Put uptime
    uptime=$(uptime | gawk '{ print  $3 $4 }' | sed 's/,.*//' )
    #| sed 's/,.*//'`
    #hour=$(echo $uptime | sed 's/\:.*//g')
    #min=$(echo $uptime | sed 's/.*\://g')
    #UP="$hour h $min m"
echo -e "<span color='black' bgcolor='#00FFFF'>:$uptime</span>\n"

    #printf "%s\n" "UP:$uptime"
#done

