#!/usr/bin/env bash

# Author : Bhaskar Chowdhury
# LICENSE : GPL-2
# For kernel download helper script: https://git.kernel.org/pub/scm/linux/kernel/git/mricon/korg-helpers.git/tree/get-verified-tarball


get_make=$(command -v make)
get_elapsed_time="/usr/bin/time -f"
untar_it="tar -xJvf"
existing_config_file="/boot/config-$(uname -r)"
build_dir=$HOME/latest_kernel_build
get_it=$(command -v secure_kernel_tarball)
NOTIFY=$(command -v notify-send)

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

debian_kernel_build() {

#Download the kernel and get into the download dir
which_kernel

eval ${get_it} ${kernel}

#Untar it
$untar_it linux-$kernel.tar.xz

#Get into the kernel direcory
cd linux-$kernel

#Clean the dir
$get_make clean && $get_make mrproper

#Copying existing/running kernel config
cp $existing_config_file .config

#Disable this option to shorten the compile time
scripts/config --disable DEBUG_KERNEL
grep DEBUG_KERNEL .config

#Disable this option to shorten the compile time
scripts/config --disable DEBUG_INFO
grep DEBUG_INFO .config

#This is needed ,otherwise it won't allow you to build
scripts/config --disable system_trusted_keys
grep CONFIG_SYSTEM_TRUSTED_KEYS .config

#Make sure the flags symbols are set correctly with an updated value
$get_make  ARCH=x86_64 olddefconfig

# Now build it
$get_elapsed_time "\n\n\tTime Elapsed: %E\n\n" $get_make ARCH=x86_64 V=1 -j$(getconf _NPROCESSORS_ONLN) deb-pkg


printf "\n\n\n Install the generated packages aka kernel,headers,modules et al\n\n\n"

cd ..

dpkg -i *.deb
}

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

debian_kernel_build
