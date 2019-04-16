#!/usr/bin/env bash

#pidfile1="/var/run/dhc*.pid"
pidfile2="/var/run/wicd/wicd.pid"
syspath1="/proc/sys/net/ipv4/conf/wlp3s0"
syspath2="/proc/sys/net/ipv4/conf/wlan0"
GET_DHCP=$(if [[ -e $pidfile2 ]] || [[ -e $syspath1 ]] || [[  -e $syspath2 ]];then

   echo "ON"

else 

  echo "OFF"
fi
)
if [[ $GET_DHCP ==  *"ON"* ]]  
then   
            STATUS="ON"
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

