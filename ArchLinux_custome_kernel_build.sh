#!/bin/bash

#This script's information based on this wiki page : https://wiki.archlinux.org/index.php/Kernels/Arch_Build_System

EFIBOOTDIR=/boot/efi/EFI/ArchLinux
DT=`date '+%d_%m_%Y_%T'`


printf "This script is running to autome the custom/latest kernel build process...have patience \n\n\n"


printf " Today is `date` "
printf "\n\n\n\n\n"

printf "Get the latest kernel version from kernel.org \n\n\n"

kernel=`curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)'`
echo $kernel

printf "Create a directory to hold and download the latest kernel from kernel.org \n\n\n"

mkdir -p build_cust_kernel_$DT

printf "Get into it...\n\n"

cd build_cust_kernel_$DT
pwd

printf "Checking out latest linux from kernel.org \n\n\n"

asp checkout linux

if [[ $! == 0 ]];then
 
  echo "Alright.. continue..."

else
  
  echo "Nope abort!"
   exit 1
fi

printf "Change the kernel name in PKGBUILD file to the pkgbase parameter ....\n\n\n"

cd /build_cust_kernel_$DT/linux/repos/core-x86_64/


sed -i 's/pkgbase=linux/#pkgbase-linux/' PKGBUILD


sed -i "s/#pkgbase=linux-custom/pkgbase=linux-$(echo $DT)/"  PKGBUILD


patch_version=`grep "pkgver=" PKGBUILD`

sed -i "s/$(echo $patch_version)/pkgver=$(echo $kernel)/" PKGBUILD



printf "As we have change the PKGBUILD file ,we need to generate the new checksum for the file ....\n\n\n"

updpkgsums


printf "Lets do the compiling now ....\n\n\n"

time makepkg -s


printf "Install the package with pacman ..\n\n\n"

pacman -U linux-$DT-headers-*.tar.xz

pacman -U linux-$DT-*.tar.xz


printf "Done..now copy over the image to EFI dir..\n\n\n\n"

cp -v /boot/vmlinuz-linux-$DT $EFIBOOTDIR
cp -v /boot/initramfs-linux-$DT.img $EFIBOOTDIR


exit 0


