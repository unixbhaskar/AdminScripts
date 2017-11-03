#!/bin/bash

major_version=
minor_version=
patch_version=
echo "Lets compile the new kernel ...but before that do a flight check.."
echo

echo "Get the kernel from kernel.org"

echo
echo " This is for stable kernel.."

wget -c https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$major_version.$minor_version.$patch_version.tar.xz
echo $?

echo 
echo "Get the sign for the kernel ..."
echo

wget -c https://cdn.kernel.org/pub/linux/kernel/v$major_version.x/linux-$major_version.$minor_version.$patch_version.tar.sign
echo $?

echo 
echo " Move the kernel to /usr/src dir "
echo

mv -v linux-$major_version.$minor_version.$patch_version.tar.xz /usr/src/
mv -v linux-$major_version.$minor_version.$patch_version.tar.sign /usr/src/

echo

echo 
echo " Getting into the dir ..."

cd /usr/src

pwd


echo 
echo " Decompress the downloaded kernel ..."
echo

unxz linux-$major_version.$minor_version.$patch_version.tar.xz
echo $?


echo 
echo " Lets check the kernel signing..."
echo

gpg2 --verify linux-$major_version.$minor_version.$patch_version.tar.sign



echo 
echo " Untar the kernel ..."
echo 

tar -xvf linux-$major_version.$minor_version.$patch_version.tar

echo
echo " Get into the kernel tree and clean it .."
echo

cd linux-$major_version.$minor_version.$patch_version

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

cp arch/x86/boot/bzImage /boot/vmlinuz-$major_version.$minor_version.$patch_version

echo
echo " Cross check the item ..."
echo

ls -al /boot/vmlinuz-*

echo
echo " Copy the System.map file to /boot dir"
echo

cp System.map /boot/System.map-$major_version.$minor_version.$patch_version

echo
echo " Again checking the timestamp"

ls -al /boot/System.map-*

echo
echo " Copying the .config file to /boot dir "
echo
cp .config /boot/config-$major_version.$minor_version.$patch_version

echo 
echo "Backup the old System.map file ..."
echo

cd /boot
pwd


mv -v Systeme.map-$major_version.$minor_version.$patch_version  System.map

echo 
#echo " Unlink the kernel pointer and link to latest kernel "
#echo

#unlink kernel 

#ln -s vmlinux-`date +"%Y%m%d_%H%M%S"` vmlinuz

#echo

echo " Now,you should fix the EFI boot loader with correct entry and reboot"
