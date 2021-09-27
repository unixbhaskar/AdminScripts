#!/bin/bash -
#===============================================================================
#
#          FILE: update.sh
#
#         USAGE: ./update.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 08/28/2019 12:23
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
# count how many updates we have got
debups=$(/usr/lib/update-notifier/apt-check --human-readable | head -1 | awk '{print $1;}')

# print the results
if [[ "$debups" -eq "1" ]]
then
	  echo "There is 1 update"
  elif [[ "$debups" -gt "1" ]]
  then
	    echo "There are $ups updates"
    else
	      echo "Up to date"
fi

