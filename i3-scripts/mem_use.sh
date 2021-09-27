#!/usr/bin/env bash

case $BLOCK_BUTTON in
	1) notify-send "Memory hog processes:
	$(ps axch -o cmd:15,%mem --sort=-%mem | head)";;
esac
mem=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
echo -e "<span color='black' bgcolor='#FFD700'> : $mem</span>\n"
#echo "Mem:$mem"
