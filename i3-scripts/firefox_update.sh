#!/bin/bash - 
#===============================================================================
#
#          FILE: firefox_update.sh
# 
#         USAGE: ./firefox_update.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independend
#       CREATED: 07/18/2019 17:00
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Use the architecture of the current machine or whatever the user has
# set externally
ARCH=${ARCH:-$(uname -m)}

if [ "$ARCH" = "x86_64" ]; then
	  LIBDIRSUFFIX="64"
  elif [[ "$ARCH" = i?86 ]]; then
	    ARCH=i686
	      LIBDIRSUFFIX=""
      else
	        echo "The architecture $ARCH is not supported." >&2
		  exit 1
fi


# Set to esr or beta to track ESR and beta channels instead of regular Firefox
FFESR=${FFESR:-N}

if [ "$FFESR" = "Y" ]; then
	  FFCHANNEL=esr-latest
fi

FFCHANNEL=${FFCHANNEL:-latest}

if [ "$FFCHANNEL" = "esr" ]; then
	  FFCHANNEL=esr-latest
  elif [ "$FFCHANNEL" = "beta" ]; then
	    FFCHANNEL=beta-latest
fi

# This defines the language of the downloaded package
FFLANG=${FFLANG:-en-US}

latest_version=${latest_version:-$(wget --spider -S --max-redirect 0 "https://download.mozilla.org/?product=firefox-${FFCHANNEL}&os=linux${LIBDIRSUFFIX}&lang=${FFLANG}" 2>&1 | sed -n '/Location: /{s|.*/firefox-\(.*\)\.tar.*|\1|p;q;}')}
installed_version=$(firefox --version | gawk '{ print $3 }')
echo $installed_version
if [[ "$latest_version" != "$installed_version" ]];then

   /usr/bin/notify-send --expire-time=5000  --urgency=critical "You have new browser version avialble." "New Firefox: $latest_version" 
fi


