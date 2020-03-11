#!/bin/bash - 
#===============================================================================
#
#          FILE: boot_kernel_with_qemu.sh
# 
#         USAGE: ./boot_kernel_with_qemu.sh 
# 
#   DESCRIPTION: This scripts can be used to test new kernel. The kernel and builroot have to 
#                be cloned or downloaded and importantly made them both beforehand.                   
# 
#       OPTIONS: initrd/initramfs 
#  REQUIREMENTS: https://buildroot.org/  for root filesystem.
#          BUGS: ---
#         NOTES: Quick testing new RC kernel aka mainline kernel.
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 03/11/2020 14:56
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

#This has to be run from kernel source dir or uncomment the below two lines to cd into dir

#kernel_source_dir=$(srctree)
#cd $kernel_source_dir
#this is the standard location for bzImage : linux/arch/x86_64/boot
qemu=$(command -v qemu-system-x86_64)
bzimage=$1
initrd=$2
rootfs="/home/bhaskar/git-linux/buildroot/output/images/rootfs.ext4"
#Or if your buildroot location is dynamic , you might pass it as third parameter
#rootfs=$3
#You need to clone and build buildroot separately to pass on as rootfs.You can find it here : https://buildroot.org/

if [[ $# -eq "" ]];then
	echo "You need to pass the bzImage and initrd location"
	echo "$0 \$1{srctree}/arch/x86_64/boot/bzImage  \$2{srctree}/initrd-{kernel_verison}.img  \$3{path_to_buildroot}/output/images/rootfs.ext4 " 
	exit 1
fi
$qemu -boot c -m 2049M -kernel $1 -initrd $2 -hda $rootfs -nographic -append "root=/dev/sda rw console=ttyS0"

