#!/bin/bash -
#===============================================================================
#
#          FILE: date_time.sh
#
#         USAGE: ./date_time.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (),
#  ORGANIZATION:
#       CREATED: 08/29/2021 17:31
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
date_time=$(date '+%d %b %Y %H:%M %a')
echo -e "<span color='black' bgcolor='#00FA9A'>:$date_time</span>\n"

cal=$(cal -1)

case $BLOCK_BUTTON in
	1) notify-send "$cal";;
esac
