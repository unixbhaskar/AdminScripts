#!/bin/sh
# 
# This script installs Swiftfox

# Download Swiftfox
echo " "
echo "Password required to install to /opt directory..."
echo " "
cd /opt
sudo wget http://getswiftfox.com/builds/releases/3.6.13/swiftfox-3.6.13-prescott.tar.bz2

# Install Swiftfox
echo " "
echo "Installing Swiftfox..."

# If there is an existing swiftfox install here let's move it out of the way
sudo mv swiftfox swiftfox.old

# Extract the build
sudo tar -jxf swiftfox-3.6.13-prescott.tar.bz2

# Search for plugins
echo " "
echo "Searching for existing plugins, errors can be safely ignored..."
sudo cp swiftfox.old/plugins/* swiftfox/plugins
sudo cp /usr/lib/firefox/plugins/* swiftfox/plugins
sudo cp /usr/lib/mozilla/plugins/* swiftfox/plugins
sudo cp /usr/lib/mozilla-firefox/plugins/* swiftfox/plugins
sudo cp /usr/lib/browser-plugins/* swiftfox/plugins
sudo cp /usr/lib/xulrunner-addons/plugins/* swiftfox/plugins

# Make sure root owns the Swiftfox directory
sudo chown -hR root:root swiftfox

# Add link in /usr/bin
sudo ln -s /opt/swiftfox/swiftfox /usr/bin/swiftfox

# Add Swiftfox to menu
cd /usr/share/applications
sudo wget http://getswiftfox.com/builds/installer/Swiftfox.desktop

# Remove the downloaded tarball
sudo rm /opt/swiftfox-3.6.13-prescott.tar.bz2

echo " "
echo "Swiftfox has been installed. Happy Surfing!"
echo " "
exit
