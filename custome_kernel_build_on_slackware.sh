#!/usr/bin/env bash
set -vx
# Author: Bhaskar Chowdhury <unixbhaskar@gmail.com>
# LICENSE: GPL-2
# Check out: https://www.kernel.org/doc/html/latest/kbuild/index.html
# For kernel download helper script: https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tree/get-verified-tarball

get_make=$(command -v make)
get_elapsed_time="/usr/bin/time -f"
untar_it="tar -xJvf"
existing_config_file="/boot/config-$(uname -r)"
build_dir=$HOME/latest_kernel_build
get_it=$(command -v secure_kernel_tarball)
EFIMENUENTRY="/boot/efi/loader/entries"
EFIBOOTDIR="/boot/efi/EFI"
NOTIFY=$(command -v notify-send)
LOCAL_BIN="/usr/local/bin"
dracut=$(command -v dracut)
clang="CC=clang"
make_llvm="LLVM=1"
llvm_assm="LLVM_IAS=1"

clear
cat << "EOF"
  _  __                    _
 | |/ /___ _ __ _ __   ___| |
 | ' // _ \ '__| '_ \ / _ \ |
 | . \  __/ |  | | | |  __/ |
 |_|\_\___|_|  |_| |_|\___|_|_ _       _   _
  / ___|___  _ __ ___  _ __ (_) | __ _| |_(_) ___  _ __
 | |   / _ \| '_ ` _ \| '_ \| | |/ _` | __| |/ _ \| '_ \
 | |__| (_) | | | | | | |_) | | | (_| | |_| | (_) | | | |
  \____\___/|_| |_| |_| .__/|_|_|\__,_|\__|_|\___/|_| |_|
                      |_|
EOF

if [[ ! -d $build_dir ]];then
	mkdir -p $build_dir
fi

cd $build_dir


slackware_kernel_build() {

#Download the kernel

which_kernel

eval ${get_it} ${kernel}

#Untar it
$untar_it linux-$kernel.tar.xz

#Get into the kernel direcory
cd linux-$kernel

#Check for required tools to build kernel
scripts/ver_linux

#Copying the existing system running kernel config
cp $existing_config_file .config

# Take away the DEBUG options for faster compile
scripts/config --disable DEBUG_KERNEL
grep DEBUG_KERNEL .config

#Similar vein like above, for faster compile time
scripts/config --disable DEBUG_INFO
grep DEBUG_INFO .config

#Make old kernel config set as well
$get_make olddefconfig


printf "Then make it ...\n\n"

which_compiler

#$get_elapsed_time "\t\n\n Elapsed time: %E\n\n" $get_make V=1 ARCH=x86_64 -j$(getconf _NPROCESSORS_ONLN) LOCALVERSION=-$(hostname)


$NOTIFY --urgency=critical 'Kernel compilation done'

if [[ $? == 0 ]];then

printf "Done\n\n"

else

printf "Error encountered\n\n"

fi


$NOTIFY --urgency=critical 'Modules install done'

printf "\n\n Copying the build kernel to boot directory\n\n"

cp arch/x86/boot/bzImage /boot/vmlinuz-$kernel-$(hostname)
$NOTIFY --urgency=critical 'Kernel install to local boot dir'


printf " Cross check the item ...\n\n"

ls -al /boot/vmlinuz-*

printf "\n\n Copy the System.map file to /boot dir\n\n"

cp System.map /boot/System.map-$kernel-$(hostname)

printf "Copying the .config file to /boot dir \n\n"

cp .config /boot/config-$kernel-$(hostname)

printf "Make sure we are in right directory  ..\n\n"
cd /boot
pwd

printf "Lets relink System.map,config,huge,generic and normal against the new kernel!... \n\n"
unlink System.map
ln -s Systeme.map-$kernel-$(hostname)  System.map

unlink config
ln -s config-$kernel-$(hostname) config

unlink vmlinuz
ln -s vmlinuz-$kernel-$(hostname) vmlinuz

unlink vmlinuz-huge
ln -s vmlinuz-$kernel-$(hostname) vmlinuz-huge

unlink vmlinuz-generic
ln -s vmlinuz-$kernel-$(hostname) vmlinuz-generic

find . -maxdepth 1 -type l -ls

printf "Done and looks good! \n\n"

printf "Copying the image to EFI directory ....\n\n"

cp -v /boot/vmlinuz-$kernel-$(hostname) $EFIBOOTDIR/slackware/

ls -al /boot/efi/EFI/slackware/*

$NOTIFY --urgency=critical 'Copied kernel to UEFI boot dir'

printf "\n\n  Fixing the menu entry of the loader....\n\n\n"

>$EFIMENUENTRY/Slackware.conf

echo "title Slackware" > $EFIMENUENTRY/Slackware.conf
echo "linux /EFI/slackware/vmlinuz-$kernel-$(hostname)" >> $EFIMENUENTRY/Slackware.conf
echo "options root=PARTUUID=d3fe6218-506b-4ed1-ac14-97adb053baff rw" >> $EFIMENUENTRY/Slackware.conf


printf "Let see the entry to confirmation...\n\n\n"

cat $EFIMENUENTRY/Slackware.conf

$NOTIFY --urgency=critical 'Modified boot entry with latest kernel'

printf "\n\n  Fix the UEFI boot shell script... ..\n\n\n"

echo "\EFI\slackware\vmlinuz-$kernel-$(hostname) root=PARTUUID=d3fe6218-506b-4ed1-ac14-97adb053baff rw" > /boot/efi/EFI/slackware.nsh

cat $EFIBOOTDIR/slackware.nsh


printf " Cleaning up the build directory .....\n\n"

rm -rf $build_dir


$NOTIFY --urgency=critical 'Kernel Update finished'


}

slackware_kernel_build

which_kernel() {
printf "\n\n Which kernel would be your base? Stable or Mainline or Longterm? [S/M/L]: %s"
read response

if [[ $response == "S" ]];then
#Get the stable kernel from kernel.org
kernel=$(curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)' | grep 5.17)
elif [[ $response == "M" ]];then
#Get the mainline kernel from kernel.org
kernel=$(curl -s https://www.kernel.org/ | grep -A1 'mainline:' | grep -oP '(?<=strong>).*(?=</strong.*)')
elif [[ $response == "L" ]];then
#Get the longterm kernel from kernel.org
kernel=$(curl -s https://www.kernel.org/ | grep -A1 'longterm:' | grep -oP '(?<=strong>).*(?=</strong.*)')
fi
}

#This is assuming that you have already installed "clang" and "llvm" in the system

which_compiler() {
printf "\n\t Which compiler do you want to use for build ,CLANG or GCC? [C/G] : %s"
read compiler_chosen

if [[ $compiler_chosen == "G" ]];then

       gcc_compile

elif [[ $compiler_chosen == "C" ]];then

       clang_llvm_compile
else
                printf "\n\n You have to choose a compiler to build.\n"
	        exit 1

fi
}

     gcc_compile() {

                printf "\n You have chosen to use GCC as the compiler to build.\n\n"

		$get_make  ARCH=x86_64 olddefconfig

		$get_elapsed_time "\t\n\n Elapsed Time : %E \n\n"  $get_make ARCH=x86_64 V=1 -j$(getconf _NPROCESSORS_ONLN) LOCALVERSION=-$(hostname)

		$get_make cleandocs

		$get_make modules_install

}

clang_llvm_compile() {
		printf "\n\t You have chosen to use CLANG as the compiler to build.\n\n"

		$get_make $clang $host_clang_cc $llvm_make $llvm_assm  ARCH=x86_64 olddefconfig

	        $get_elapsed_time "\n\t Elapsed Time: %E \n\n" $get_make $clang $host_clang_cc $llvm_make $llvm_assm  ARCH=x86_64 V=1 -j$(getconf _NPROCESSORS_ONLN)

		$get_make cleandocs

		$get_make $clang $llvm_make $llvm_assm modules_install

}
