#!/usr/bin/env bash



##Check VPN status
#GET_VPN=$(nmcli con show | grep tun0 | cut -d ' ' -f1)
#GET_VPN=$([ -e /proc/sys/net/ipv4/conf/tun0]) 
GET_VPN=$( if [[ -e /proc/sys/net/ipv4/conf/tun0 ]];then
         echo "tun0"
else
	echo "no vpn"

fi
)

##Store status in STATUS
if [[ $GET_VPN == *"tun0"* ]]
then   
	    STATUS=ON
    else
	        STATUS=OFF
	fi



echo $STATUS
echo $STATUS



	##Colors
	if [[ "$STATUS" == "ON" ]]
	then
		    echo "#00ff00"
	    else
		        echo "#ff0000"
		fi			
