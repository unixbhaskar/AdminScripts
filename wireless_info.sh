#!/bin/bash

wireless_dev=`ip a | grep w | gawk -F: ' { print $2 } '`

echo " The wireless device information of this system `hostname`..."
echo
echo


echo
echo " Let;s find out about wireless card and driver of this system ..."
echo

lshw -C network | grep -B 1 -A 12 'Wireless interface'

echo 
echo

echo " Checking the quality of signal of the wireless device ....."
echo

iwconfig  $wireless_dev | grep -i --color quality

echo 
echo
sleep 5

echo " Show the wireless device properly of this system ...."
echo
echo

nmcli -f GENERAL,WIFI-PROPERTIES dev show  $wireless_dev 

echo
echo
echo

sleep 5

echo "Show me the wireless network avaialble around ...."
echo
echo

nmcli  dev wifi

echo
echo
echo

echo "Need to know the device info...."
echo

iw $wireless_dev info


exit 0
