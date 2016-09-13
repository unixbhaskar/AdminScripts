#!/bin/sh
#
# This script installs Adobe Flash Player to your user directory

# Make sure the plugins directory exists
mkdir ~/.mozilla/plugins

# Download Flash Player from Adobe
wget http://fpdownload.macromedia.com/get/flashplayer/current/install_flash_player_10_linux.tar.gz

# Extract the tarball
tar zxf install_flash_player_10_linux.tar.gz

# Copy the plugin to the correct location
cp install_flash_player_10_linux/libflashplayer.so ~/.mozilla/plugins/libflashplayer.so

# Delete the tarball and extracted directory
rm -rf install_flash_player_10_linux
rm install_flash_player_10_linux.tar.gz

# End of installation
echo " "
echo "Adobe Flash Player has been installed"
echo " "

exit