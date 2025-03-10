#!/usr/bin/env bash
get_make=$(command -v make)
get_elapsed_time="/usr/bin/time -f"
untar_it="tar -xJvf"
get_it=$(command -v secure_kernel_tarball)
NOTIFY=$(command -v notify-send)
NOCOLOR="\033[0m"
DT=$(date '+%d%m%Y')
build_dir="/home/bhaskar/custom_kernel_$(hostname)_$DT"

if test ! -d "$build_dir";then
	mkdir -p "$build_dir"
fi

cd "$build_dir" || exit 1


#vim "/etc/mkinitcpio.d/linux-upstream.preset"

archlinux_kernel_build() {

which_kernel

printf "\n\n"

# Change the kernel name
sh -c "sudo sed -i '4d' /etc/mkinitcpio.d/linux-upstream.preset"
sh -c "sudo sed -i '4i ALL_kver=\"/boot/vmlinuz-linux-upstream-${kernel}-Archlinux\"' /etc/mkinitcpio.d/linux-upstream.preset"

sh -c "sudo sed -i '8d' /etc/mkinitcpio.d/linux-upstream.preset"
sh -c "sudo sed -i '8i default_image=\"/boot/initramfs-linux-upstream.img-${kernel}-Archlinux\"' /etc/mkinitcpio.d/linux-upstream.preset"

eval ${get_it} ${kernel}


#Untar it
$untar_it linux-$kernel.tar.xz


#Get into the kernel direcory
cd linux-$kernel

# Take away the debug package option for faster build

sed -i '8d' scripts/package/PKGBUILD
sed -i '8i  _extrapackages=${PACMAN_EXTRAPACKAGES-headers api-headers}' scripts/package/PKGBUILD
sed -i '114,125 s/^/#/' scripts/package/PKGBUILD

# Creating a new checksum, because we have modified the PKGBUILD file

#updpkgsums scripts/package/PKGBUILD

#Clean the dir
$get_make clean && $get_make mrproper

#Copying existing/running kernel config
zcat /proc/config.gz >.config

#Disable this option to shorten the compile time
scripts/config --disable DEBUG_KERNEL
grep DEBUG_KERNEL .config

#Disable this option to shorten the compile time
scripts/config --disable DEBUG_INFO
grep DEBUG_INFO .config

# Enable USB storage module for external HDD
scripts/config --enable USB_STORAGE

# Set the local version of the operating system name
scripts/config --set-str LOCALVERSION "-Archlinux"

#Make sure the flags symbols are set correctly with an updated value
#$get_make  ARCH=x86_64 olddefconfig
yes '' | make localmodconfig


# Now build it
$get_elapsed_time "\n\n\tTime Elapsed: %E\n\n" $get_make ARCH=x86_64 V=1 -j$(getconf _NPROCESSORS_ONLN) pacman-pkg

if test $? -eq 0
then
     $NOTIFY --urgency=critical "Kernel building done"


     printf "\nFirst take backup of the existing kernel and initramf to the backups.....\n\n"

     sudo sh -c "mv -v "/boot/*-Archlinux" "/home/bhaskar/arch_linux_old_kernels/""

     printf "\n Cross checking the latest movement of the kernel and initramfs in backup\n\n"

     find  "/home/bhaskar/arch_linux_old_kernels/" -type f  -ls

     printf "\n Check the latest genrated package files.....\n"

     find . -maxdepth 1 -name "*.zst" -type f -ls

     # printf "\n Signing the packages with my GPG key.....\n"

     # sh -c "gpg2 --detach-sign --pinentry-mode loopback --passphrase --passphrase-fd 0 --output *.pkg.tar.zst.sig --sign *.pkg.tar.zst"

     printf "\n Now install the generated headers,kernel and doc packages with pacman .. \n\n\n"


     sudo pacman -U  --noconfirm linux-upstream-$kernel_Archlinux-1-x86_64.pkg.tar.zst

     sudo pacman -U --noconfirm linux-upstream-headers-$kernel_Archinux-1-x86_64.pkg.tar.zst

     sudo pacman -U --noconfirm linux-upstream-api-headers-$kernel_Archlinux-1-x86_64.pkg.tar.zst

else
	echo Something went wrong, manually check.
fi
#$NOTIFY "Kernel update process done"
}

which_kernel() {
printf "\n\n Which kernel would be your base? Stable or Mainline or Longterm? [S/M/L]: %s"
read response

if [[ $response == "S" ]];then
#Get the stable kernel from kernel.org
kernel=$(curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)' | grep 6.13)
elif [[ $response == "M" ]];then
#Get the mainline kernel from kernel.org
kernel=$(curl -s https://www.kernel.org/ | grep -A1 'mainline:' | grep -oP '(?<=strong>).*(?=</strong.*)')
elif [[ $response == "L" ]];then
#Get the longterm kernel from kernel.org
kernel=$(curl -s https://www.kernel.org/ | grep -A1 'longterm:' | grep -oP '(?<=strong>).*(?=</strong.*)')
fi
}

archlinux_kernel_build
