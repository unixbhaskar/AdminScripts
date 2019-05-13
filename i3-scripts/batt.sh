#!/usr/bin/env bash

################################
# Shows info about connected batteries.
#
# Dependencies:
# - acpi
#
# @return {Number(%)}: Current battery charge
################################

dir=$(dirname $0)
source $dir/util.sh

full=""
short=""
stat=0

# Exit if no battery was found
if [[ "$(acpi)" == "" ]]; then exit 0; fi

state=$(acpi | sed -n 's/Battery [0]: \([A-Z]\).*, .*/\1/p')
state1=$(acpi | sed -n 's/Battery [1]: \([A-Z]\).*, .*/\1/p')
chg=$(acpi | sed -n 's/Battery [0]:.*, \([0-9]\{1,3\}\)%.*/\1/p')
chg2=$(acpi | sed -n 's/Battery [1]:.*, \([0-9]\{1,3\}\)%.*/\1/p')

# Charging or Unknown
if [[ $state == "C" ]] || [[ $state == "U" ]] && [[ $state1 == "C" ]] || [[ $state1 == "U" ]];then
        
	icon=""
fi
if [[ $state != "C" ]] && [[ $state1 != "C" ]];then
           icon=""
fi
    
if [[ $chg -le 10 ]] && [[ $chg2 -le 10 ]];then 
		icon=""
		stat=33
		LEVEL="critical"
  	
/usr/bin/notify-send --expire-time=0 --urgency=$LEVEL "Battery critical,please connect to power socket" "Exit Code: $LEVEL"
fi
full="$icon $chg% $icon $chg2%"
short="$chg% $chg2%"

echo $full
echo $short
exit $stat
