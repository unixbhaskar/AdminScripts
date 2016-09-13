#!/bin/sh
#
# This script uninstalls Swiftfox that was installed using the installer

echo " "
echo "Uninstalling Swiftfox..."
echo " "
sudo rm -rf /opt/swiftfox
sudo rm /usr/bin/swiftfox
sudo rm ~/Desktop/Swiftfox.desktop
sudo rm /usr/share/applications/Swiftfox.desktop

echo " "
echo "Swiftfox has been uninstalled"
echo " "
exit