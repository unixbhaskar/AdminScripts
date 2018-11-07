#!/bin/bash

output=""
for i in 1 0
do
	LEVEL=$(cat /sys/class/power_supply/BAT$i/capacity)
	STATUS=$(cat /sys/class/power_supply/BAT$i/status | cut -c1-3)
	if [ "$STATUS" == "Unk" ]; then
		STATUS=""
	fi
	if [ ${#output} -eq 0 ]; then
		output="$LEVEL% $STATUS"
	else
		output="$output | $LEVEL% $STATUS"
	fi
done
echo $output
