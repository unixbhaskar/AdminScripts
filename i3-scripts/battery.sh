#!/usr/bin/env bash
output=""
for i in 1 0
do
	LEVEL=$(cat /sys/class/power_supply/BAT$i/capacity)
	STATUS=$(cat /sys/class/power_supply/BAT$i/status | cut -c1-3)
	if [ "$STATUS" == "Unk" ]; then
		STATUS=""
	fi
       
	if [ "$STATUS" == "Charging" ];then
		echo "$LEVEL% $STATUS"
	fi	
	
	if [ ${#output} -eq 0 ]; then
		output="$LEVEL% $STATUS"
	else
		output="$output | $LEVEL% $STATUS"
	fi
done
echo $output

#BATTINFO=$(acpi -b)
#warn=$(if [[ $(echo $BATTINFO | grep Discharging) && $(echo $BATTINFO | cut -f 5 -d " ") < 00:15:00 ]] ; then
#    DISPLAY=:0.0 /usr/bin/notify-send "low battery" "$BATTINFO"
#fi
#)
#done
#echo $output $warn
