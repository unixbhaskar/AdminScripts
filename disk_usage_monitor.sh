#!/bin/bash
#This is for monitoring the disk usage on any machine with an assumtion of lvm too..
dt=`date +%D`

df -h > /tmp/du$$

while read line
do
    fields=`echo $line | awk '{print NF}'`
    case $fields in
    1) echo -n "$dt $line ";;
    5) echo -n "$dt "
        echo $line | awk '{print $4}';;
    6) echo -n "$dt "
        echo $line | awk '{print $1,$5}';;
    esac
done < /tmp/du$$ > disk_usage

 cat disk_usage | mail -s "disk usage" unixbhaskar@gmail.com

rm /tmp/du$$
