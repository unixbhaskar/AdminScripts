#!/usr/bin/env bash  
#===============================================================================
#
#          FILE: cmus1.sh
# 
#         USAGE: ./cmus1.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 05/12/2019 21:19
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

ICON_PLAY="➤"
ICON_PAUSE="Ⅱ"
ICON_STOP="≠"
CUR_ICON=""

INFO_ARTIST=$(cmus-remote -Q | grep ' artist ' | cut -d ' ' -f3-)
INFO_ALBUM=$(cmus-remote -Q | grep ' album ' | cut -d ' ' -f3-)
INFO_TITLE=$(cmus-remote -Q | grep ' title ' | cut -d ' ' -f3-)

PLAYER_STATUS=$(cmus-remote -Q | grep 'status' | cut -d ' ' -f2-)

if [[ "${PLAYER_STATUS}" = "paused" ]]; then
	  CUR_ICON="${ICON_PAUSE}"
  elif [[ "${PLAYER_STATUS}" = "playing" ]]; then
	    CUR_ICON="${ICON_PLAY}"
    else
	      CUR_ICON="${ICON_STOP}"
      fi

      #if [[ "${INFO_TITLE}" != "" ]] || [[ "${INFO_ARTIST}" != "" ]] || [[ "${INFO_ALBUM}" != "" ]]; then
	        echo "${INFO_TITLE}${CUR_ICON}"
		  echo "${INFO_TITLE}${CUR_ICON}"
#	  fi
