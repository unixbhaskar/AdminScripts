#!/bin/bash

#This script's information based on this wiki page : https://wiki.archlinux.org/index.php/Kernels/Arch_Build_System

EFIBOOTDIR=/boot/efi/EFI/ArchLinux
DT=`date '+%d%m%Y'`
EFIBOOTENTRY=/boot/efi/loader/entries/

printf "This script is running to autome the custom/latest kernel build process...have patience \n\n\n"


printf " Today is `date` "
printf "\n\n\n\n\n"

printf "Get the latest kernel version from kernel.org \n\n\n"

kernel=`curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)'`
echo $kernel

printf "Create a directory to hold and download the latest kernel from kernel.org \n\n\n"

mkdir -p build_cust_kernel_$DT

printf "Get into it...\n\n\n"

cd build_cust_kernel_$DT
pwd

printf "Checking out latest linux from kernel.org \n\n\n\n"

asp checkout linux

if [[ $? == 0 ]];then
   echo "Alright.. continue..."
else
  echo "Nope abort!"
   exit 1
fi

printf "\n\n\n\n\n"

printf "*********Configuring PKGBUILD********** \n\n\n\n"

printf "Change the kernel name in PKGBUILD file to the pkgbase parameter ....\n\n\n\n"

cd linux/repos/core-x86_64/


sed -i 's/pkgbase=linux/#pkgbase=linux/' PKGBUILD


sed -i "/pkgbase=linux-custom/s/^#/pkgbase=linux-$(echo $kernel) /"  PKGBUILD



patch_version=`grep "pkgver=" PKGBUILD`

sed -i "s/$(echo $patch_version)/pkgver=$(echo $kernel)/" PKGBUILD



printf "As we have change the PKGBUILD file ,we need to generate the new checksum for the file ....\n\n\n"

updpkgsums


printf "Lets do the compiling now ....\n\n\n"

time makepkg -s


printf "Install the generated headers,kernel and doc packages with pacman ..\n\n\n"

sudo pacman -U --noconfirm linux-$kernel-headers-$kernel-1-x86_64.pkg.tar.xz

sudo pacman -U  --noconfirm  linux-$kernel-$kernel-1-x86_64.pkg.tar.xz 

sudo pacman -U  --noconfirm linux-$kernel-docs-$kernel-1-x86_64.pkg.tar.xz 


printf "Done..now copy over the image to EFI dir..\n\n\n\n"

sudo cp -v /boot/vmlinuz-linux-$kernel $EFIBOOTDIR
sudo cp -v /boot/initramfs-linux-$kernel.img $EFIBOOTDIR


printf "Fixed the boot entry now...\n\n\n\n"


echo "title ArchLinux" > $EFIBOOTENTRY/ArchLinux.conf 
echo "linux /EFI/ArchLinux/vmlinuz-linux-$kernel" >> $EFIBOOTENTRY/ArchLinux.conf
echo "initrd /EFI/ArchLinux/initramfs-linux-$kernel.img" >> $EFIBOOTENTRY/ArchLinux.conf
echo "options root=PARTUUID=e79c9191-3302-4dc8-a62a-5cc22d266643  loglevel=3  systemd.show_status=true rw" >> $EFIBOOTENTRY/ArchLinux.conf 


printf "..Okay let us see how it looks ...\n\n\n\n"

cat $EFIBOOTENTRY/ArchLinux.conf

exit 0


