#!/bin/bash

#This script information based on this wiki page : https://wiki.archlinux.org/index.php/Kernels/Arch_Build_System

NOCOLOR="\033[0m"
EFIBOOTDIR=/boot/efi/EFI/ArchLinux
DT=`date '+%d%m%Y'`
EFIBOOTENTRY=/boot/efi/loader/entries
source /home/bhaskar/colors.sh
build_dir=/home/bhaskar/latest_kernel_`hostname`_$DT
TM="/usr/bin/time -f"

printf "${Bright}${Red}This script is running to autome the custom/latest kernel build process...have patience${NOCOLOR} \n\n\n"

printf "Hostname: %s\nDate    : %s\nUptime  :%s\n\n"  "$(hostname -s)" "$(date)" "$(uptime)"


printf "Get the latest kernel version from ${Blue}kernel.org \n\n\n"

kernel=`curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)'| grep 4.16`
printf "${Bright}${GREEN}$kernel${NOCOLOR} \n"

printf "Create a directory to hold and download the latest kernel from ${Blue}kernel.org${NOCOLOR} \n\n\n"

if [[ ! -d $build_dir ]];then
   printf "${Bright}${Green}Created it ${NOCOLOR} \n\n"
    mkdir -p $build_dir
else
   printf "${Bright}${LimeYellow}Already exists! ${NOCOLOR} \n\n"
fi

printf "\n\n Get into it...\n\n\n"

cd $build_dir
pwd

printf "Checking out latest linux from ${Blue}kernel.org${NOCOLOR} \n\n\n\n"

asp checkout linux

if [[ $? == 0 ]];then
   printf "${GREEN}Alright.. continue...${NOCOLOR}\n\n\n"
else
  printf "${RED}Nope abort!${NOCOLOR}\n\n\n"
   exit 1
fi

printf "*********${Bright}${Cyan}Configuring PKGBUILD${NOCOLOR}********** \n\n\n\n"

printf "${LimeYellow}Customizing few varibles in the PKGBUILD file...${NOCOLOR}\n\n\n\n"

cd linux/repos/core-x86_64/

sudo zcat /proc/config.gz > config

sed -i 's/pkgbase=linux/#pkgbase=linux/' PKGBUILD


sed -i "/pkgbase=linux-custom/s/^#/pkgbase=linux-$(echo $kernel) /"  PKGBUILD


cn=`echo $kernel | cut -d"." -f1-2`

sed -i "s/_srcname=linux-4.15/_srcname=linux-$(echo $cn) /" PKGBUILD

patch_version=`grep "pkgver=" PKGBUILD`

sed -i "s/$(echo $patch_version)/pkgver=$(echo $kernel)/" PKGBUILD

sed -i 's/#make oldconfig/make olddefconfig/' PKGBUILD

sed -i '171d;172d' PKGBUILD

printf "As we have change the PKGBUILD file ,we need to generate the new ${Magenta}CHECKSUM the file .... ${NOCOLOR} \n\n\n"

#makepkg -g 

updpkgsums


printf "\n\n\n Lets do the ${Bright}${Green}compiling now ${NOCOLOR} ....\n\n\n"

$TM "\t\n\n Elapsed Time : %E \n\n"  makepkg -s


printf "Install the generated ${PowderBlue}headers,${PowderBlue}kernel and ${PowderBlue}doc packages with pacman .. ${NOCOLOR} \n\n\n"

sudo pacman -U --noconfirm linux-$kernel-headers-$kernel-1-x86_64.pkg.tar.xz

sudo pacman -U  --noconfirm  linux-$kernel-$kernel-1-x86_64.pkg.tar.xz 

sudo pacman -U  --noconfirm linux-$kernel-docs-$kernel-1-x86_64.pkg.tar.xz 


printf "\n\n\n Done..now copy over the image to ${Yellow}EFI dir..${NOCOLOR} \n\n\n\n"

sudo cp -v /boot/vmlinuz-linux-$kernel $EFIBOOTDIR
sudo cp -v /boot/initramfs-linux-$kernel.img $EFIBOOTDIR


printf "${Bright}${Blue}Fixed the boot entry now ${NOCOLOR}...\n\n\n\n"


sudo echo "title ArchLinux" > $EFIBOOTENTRY/ArchLinux.conf 
sudo echo "linux /EFI/ArchLinux/vmlinuz-linux-$kernel" >> $EFIBOOTENTRY/ArchLinux.conf
sudo echo "initrd /EFI/ArchLinux/initramfs-linux-$kernel.img" >> $EFIBOOTENTRY/ArchLinux.conf
sudo echo "options root=PARTUUID=e79c9191-3302-4dc8-a62a-5cc22d266643  loglevel=3  systemd.show_status=true rw" >> $EFIBOOTENTRY/ArchLinux.conf 


printf "${Bright}${Cyan} Okay let us see how it looks ${NOCOLOR} ...\n\n\n\n"

sudo cat $EFIBOOTENTRY/ArchLinux.conf

exit 0


