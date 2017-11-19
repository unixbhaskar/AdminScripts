#!/bin/bash

echo "Lets compile the new kernel on `hostname` ...but before that we need get the required stuff.."
echo

echo 
echo " Check the RC kernel version at kernel.org"
echo 

rc_kernel=`curl -s https://www.kernel.org/ | grep -A1 'mainline:' | grep -oP '(?<=strong>).*(?=</strong.*)'`

echo $rc_kernel
echo

echo "Get the kernel from kernel.org"

echo
echo " This is for rc kernel.."
wget -c https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-$rc_kernel.tar.gz 

echo $?

echo 
#echo "Get the sign for the kernel ..."
#echo

#wget -c  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/snapshot/linux-$kernel.tar.sign

#echo $?

echo 
echo " Move the kernel to /usr/src dir "
echo

mv -v linux-$rc_kernel.tar.gz /usr/src/
#mv -v linux-$major_version.$minor_version-$patch_version.tar.sign /usr/src/

echo

echo 
echo " Getting into the dir ..."

cd /usr/src

pwd


echo 
echo " Decompress the downloaded kernel ..."
echo

tar -xvzf linux-$rc_kernel.tar.gz

echo $?


#echo 
#echo " Lets check the kernel signing..."
#echo

#gpg2 --verify linux-$rc_kernel.tar.sign



#echo 
#echo " Untar the kernel ..."
#echo 

#tar -xvf linux-$rc_kernel.tar

echo
echo " Get into the kernel tree and clean it .."
echo

cd linux-$rc_kernel

make clean && make mrproper
echo
echo "Check the lastest kernel dir in /usr/src direcoty"
echo

ls -al /usr/src


echo " Now get running kernel conf and build .config "
echo

zcat /proc/config.gz > .config

echo "Check the timestamp on the file for the sanity"
echo

ls -al .config

echo " Lets do the config ...run "make olddefconfig""
echo

make olddefconfig

echo
echo " Then make it ..."

time make -j9

echo $?

if [ $? == 0 ]
then

echo "Done"

else 

echo "Error encountered"

fi

echo " Installing the modules ..."
echo

make modules_install

echo 
echo " Copying the build kernel to boot directory"
echo

cp arch/x86/boot/bzImage /boot/vmlinuz-$rc_kernel

echo
echo " Cross check the item ..."
echo

ls -al /boot/vmlinuz-*

echo
echo " Copy the System.map file to /boot dir"
echo

cp System.map /boot/System.map-$rc_kernel

echo
echo " Again checking the timestamp"

ls -al /boot/System.map-*

echo
echo " Copying the .config file to /boot dir "
echo
cp .config /boot/config-$rc_kernel

echo 
echo "Backup the old System.map file ..."
echo

cd /boot
pwd


mv  Systeme.map-$rc_kernel System.map

echo 
#echo " Unlink the kernel pointer and link to latest kernel "
#echo

#unlink kernel 

#ln -s vmlinux-`date +"%Y%m%d_%H%M%S"` vmlinuz

#echo

echo " Now,you should fix the EFI boot loader with correct entry and reboot"
