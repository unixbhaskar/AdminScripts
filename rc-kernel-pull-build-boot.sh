#!/bin/bash - 
#===============================================================================
#
#          FILE: rc-kernel-pull-build-boot.sh
# 
#         USAGE: ./rc-kernel-pull-build-boot.sh 
# 
#   DESCRIPTION: This is automated script to check RC kernel ,build, compile,boot 
# 
#       OPTIONS: ---
#  REQUIREMENTS: qemu  
#          BUGS: ---
#         NOTES: mutt integration for sending mail of the result
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 03/17/2020 15:42
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

ker_source="/home/bhaskar/git-linux/linux"
qemu=$(command -v qemu-system-x86_64)
check_version=$(grep EXTRAVERSION $ker_source/Makefile | head -1)
bzimage="$ker_source/arch/x86_64/boot/bzImage"
rootfs="/home/bhaskar/git-linux/buildroot/output/images/rootfs.ext4"
#dracut=$(command -v dracut)
#initrd="$ker_source/initrd-rootfile.img"

build_kernel_and_boot_with_qemu(){

	make clean && make mrproper
	cp  /boot/config-$(uname -r | tr -d - | tr -d [:alpha:]) .config
	make olddefconfig
	make ARCH=x86_64 -j $(getconf _NPROCESSORS_ONLN) LOCALVERSION=-$(hostname) 
	make modules
	$qemu -boot c -m 2049M -kernel $bzimage  -hda $rootfs -nographic -append "root=/dev/sda rw console=ttyS0"
        return 0
}

#boot_with_initrd(){

#	$dracut -l -o $initrd
#	$qemu -boot c -m 2049M -kernel $bzimage -initrd $initrd  -hda $rootfs -nographic -append "root=/dev/sda rw console=ttyS0"
#        return 0
#}

cd $ker_source && git pull

if [[ $? -eq "0" ]];then
	echo "Alright..proceed"
else
	echo "Run git pull again."
	git pull
fi

echo "Check version to proceed further..."

post_pull_version=$(grep EXTRAVERSION $ker_source/Makefile | head -1)

if [[ "$check_version" != "$post_pull_version" ]];then
	echo "We have new RC kernel"
         build_kernel_and_boot_with_qemu
#elif [[ $? -ne "0" ]];then
#        boot_with_initrd 

else
	echo "We do not have new RC kernel"
fi


