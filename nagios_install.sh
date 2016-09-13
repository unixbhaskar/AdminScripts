#!/bin/bash
# This script will install Nagios from source along with the plugins.
dir=/usr/local/nagios
if [[ ! -d $dir ]]
then
  echo "Creating the directory to hold nagios.."
   mkdir -p $dir
   echo "..Done"
echo
echo

echo " Getting the nagios tarball along with plugins from Sourceforge site....please be patience"
echo

wget http://osdn.dl.sourceforge.net/sourceforge/nagios/nagios-3.0.6.tar.gz
wget http://osdn.dl.sourceforge.net/sourceforge/nagiosplug/nagios-plugins-1.4.11.tar.gz

echo " Just checking the version of Redhat.."
 
grep -i “red hat” /etc/issue>>/dev/null2>>&1

if [ `echo $? ` = 0 ];then

echo " If the previos stat return true then..addming user and group to it.."
useradd nagios
else
groupadd nagios
useradd -G nagios nagios
fi
echo " Extracting the nagios plugins...."

tar xzf nagios-plugins-1.4.11.tar.gz
echo " Now getting into that untared dir.."

cd nagios-plugins-1.4.11
echo " Time to configure the plugins with proper options"
./configure –prefix=/usr/local/nagios –enable-redhat-pthread-workaround
echo
echo " Making it..."

make

echo " Installing it..."
make install

echo "..Done."
cd ..
echo " Untarting the nagios from source tarball..." 
tar xzf nagios-3.0.6.tar.gz
echo "Getting into the new untar nagios dir..."
cd nagios-3.0.6
echo " Time to do all the configure,make and other stuff to do..."
./configure –prefix=/usr/local/nagios
make install
make install-init
make install-config
make install-commandmode
make install-webconf
# make sure xinetd is installed.
echo ” nrpe  5666/tcp  #nrpe” »» /etc/services
echo "Changing ownership of the dir..."
chown -R nagios.nagios /usr/local/nagios
echo " Start the xinetd service...."
service xinetd [...]

