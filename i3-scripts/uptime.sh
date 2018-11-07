#!/bin/sh

/usr/bin/i3status -c $HOME/.config/i3/i3status.conf | while : 


do
    read line
    #RAM=`free -kh | grep Mem | awk '{print $3}'`
    #TOTR=$(cat /proc/meminfo | grep MemT | sed 's/.*\://g' | sed 's/ *//g' | sed 's/kB//g')
    #TOT=$(octave --eval "$TOTR/1024^2" | sed 's/ans = *//g' | sed 's/$/G/g' )

    # Put uptime
    uptime=`uptime | awk '{print $3 }' | sed 's/,.*//'`
    #hour=$(echo $uptime | sed 's/\:.*//g')
    #min=$(echo $uptime | sed 's/.*\://g')
    #UP="$hour h $min m"


    printf "%s\n" " Up: $uptime | $line"
done

