#!/usr/bin/env bash

#Author : Bhaskar CHowdhury
#LICENSE : GPL-2
#This script information based on this wiki page : https://wiki.archlinux.org/index.php/Kernels/Arch_Build_System

EFIBOOTDIR=/boot/efi/EFI/ArchLinux
DT=$(date '+%d%m%Y')
EFIBOOTENTRY=/boot/efi/loader/entries
build_dir=/home/bhaskar/latest_kernel_$(hostname)_$DT
TM="/usr/bin/time -f"
KERNEL_PKG_DIR="/home/bhaskar/latest_kernel_build/linux/repos/core-x86_64/"

printf "Hostname: %s\nDate    : %s\nUptime  :%s\n\n"  "$(hostname -s)" "$(date)" "$(uptime)"


kernel=$(arch_linux_latest_tag | sed -e 's/...$//' | tr -d "-" | tr -d "arch" | tr -d "v")
printf '%s\n' "$kernel"

# checking if the build is exist , if not ceate it

if [[ ! -d "$build_dir" ]];then
   printf "Created it\n\n"
    mkdir -p $build_dir
else
   printf "Already exists! \n\n"
fi

printf "\n\n Get into it...\n\n\n"

cd $build_dir
pwd

printf "Checking out latest linux \n\n\n\n"

asp checkout linux

if [[ $? == 0 ]];then
   printf "Alright.. continue...\n\n\n"
else
  printf "Nope abort!\n\n\n"
   exit 1
fi

printf "*********Configuring PKGBUILD********** \n\n\n\n"

arch_repo=linux/repos/core-x86_64/
cd $arch_repo

sudo zcat /proc/config.gz > config

# Turning off like this help build kernel faster, but pose difficulty while debugging

sed -i "s/"CONFIG_DEBUG_KERNEL=y"/"CONFIG_DEBUG_KERNEL=n"/" config
grep DEBUG_KERNEL config
sed -i "s/"CONFIG_DEBUG_INFO=y"/"CONFIG_DEBUG_INFO=n"/" config
grep DEBUG_INFO config

sed -i "s/pkgbase=linux/pkgbase=$(hostname)-$(echo $kernel) /"  PKGBUILD
pkgver=$(grep "pkgver" PKGBUILD | head -1)
sed -i "s/$(echo $pkgver)/pkgver=$(echo $kernel) /" PKGBUILD

sed -i '7d' PKGBUILD
sed -i '7i _srcver=${pkgver%%%.*}-arch1 '  PKGBUILD
sed -i '17d' PKGBUILD
sed -i '17i _srcname=${pkgver%%%.*}-arch1'  PKGBUILD

sed -i '19d' PKGBUILD
sed -i '19i \"$_srcname::https://github.com/archlinux/linux/archive/refs/tags/v$_srcname.tar.gz\"' PKGBUILD
sed -i '31d' PKGBUILD
sed -i '31i export KBUILD_BUILD_HOST=Bhaskar_ThinkPad_x250' PKGBUILD
sed -i '32d' PKGBUILD
sed -i '32i export KBUILD_BUILD_USER=Bhaskar' PKGBUILD
sed -i '36d' PKGBUILD
sed -i '36i cd src/linux-$_srcname' PKGBUILD
sed -i 's/#make oldconfig/make olddefconfig/' PKGBUILD
sed -i '62d' PKGBUILD
sed -i '62i make V=1 ARCH=x86_64 -j4' PKGBUILD
sed -i '63d' PKGBUILD
sed -i '174,192 s/^/#/' PKGBUILD
sed -i '193d' PKGBUILD
sed -i '193i pkgname=("$pkgbase" "$pkgbase-headers")' PKGBUILD

printf "As we have change the PKGBUILD file ,we need to generate the new CHECKSUM the file ....  \n\n\n"

#makepkg -g

updpkgsums


printf "\n\n\n Lets do the compiling now  ....\n\n\n"

$TM "\t\n\n Elapsed Time : %E \n\n"  makepkg -s


printf "Install the generated headers,kernel and doc packages with pacman .. \n\n\n"


cd $KERNEL_PKG_DIR

sudo pacman -U  --noconfirm $(hostname)-$kernel-$kernel-1-x86_64.pkg.tar.zst

sudo pacman -U --noconfirm $(hostname)-$kernel-headers-$kernel-1-x86_64.pkg.tar.zst


# printf "\n\n\n Done..now copy over the image to ${Yellow}EFI dir..${NOCOLOR} \n\n\n\n"

# sudo cp -v /boot/vmlinuz-$(hostname)-$kernel $EFIBOOTDIR/$(hostname)/
# sudo cp -v /boot/initramfs-$(hostname)-$kernel.img $EFIBOOTDIR/$(hostname)/


# printf "Fixed the boot entry now ...\n\n\n\n"

# echo "title ArchLinux" | sudo tee  $EFIBOOTENTRY/ArchLinux.conf
# echo "linux /EFI/ArchLinux/vmlinuz-$(hostname)-$kernel" | sudo tee -a $EFIBOOTENTRY/ArchLinux.conf
# echo "initrd /EFI/ArchLinux/initramfs-$(hostname)-$kernel.img" | sudo tee -a $EFIBOOTENTRY/ArchLinux.conf
# echo "options root=PARTUUID=9e3d2f9a-4846-3049-97fc-b5e5c61820ae  loglevel=3  systemd.show_status=true rw" | sudo tee -a $EFIBOOTENTRY/ArchLinux.conf

# printf "\n\n\n Modified the UEFI script...  \n\n"

# echo "\EFI\ArchLinux\vmlinuz-$(hostname)-$kernel root=PARTUUID=9e3d2f9a-4846-3049-97fc-b5e5c61820ae  loglevel=3  systemd.show_status=true rw initrd=\EFI\ArchLinux\initramfs-$(hostname)-$kernel.img" | sudo tee  /boot/efi/EFI/archlinux.nsh
exit 0
