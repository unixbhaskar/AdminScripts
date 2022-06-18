#!/bin/bash -
#===============================================================================
#
#          FILE: ffmpeg_build_from_upstream_on_slackware.sh
#
#         USAGE: ./ffmpeg_build_from_upstream_on_slackware.sh
#
#   DESCRIPTION: Build latest version of ffmpeg from upstream
#
#       OPTIONS: ---
#  REQUIREMENTS: Need to run it as root or with sudo for systemlib
#          BUGS: ---
#         NOTES: Update to the latest version
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 06/18/2022 07:36
#      REVISION: 1.0
#===============================================================================

set -o nounset                              # Treat unset variables as an error


# Get the latest version from upstream
rsync -avz rsync://mirrors.kernel.org/slackware/slackware-current/source/l/ffmpeg .

cd ffmpeg

# Extract out the version numeric from the package name
version=$(find . -name "*.xz" -type f -print | sed -e 's#ffmpeg# #' | sed -e 's#tar.xz# #' | sed -e 's#.$# #'  | sed -e 's#^./-# #')

# Change the permission of the package build script,give exec bit
chmod +x ffmpeg.SlackBuild

echo "Building it ...."

# This directing the build script to use x264 video codecs
X264=yes ./ffmpeg.SlackBuild

# Checking if the build went alright or not and take decision based on it
if [[ $? -eq 0 ]];then
	echo installing the package.

	installpkg  /tmp/ffmpeg-$version-x86_64-1.txz

else
	echo Build is not ok.cross check it...
fi