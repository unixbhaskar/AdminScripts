#!/bin/bash -
#===============================================================================
#
#          FILE: freebsd_vm.sh
#
#         USAGE: ./freebsd_vm.sh
#
#   DESCRIPTION: Run FreeBSD inside a virtual machine on Linux
#
#       OPTIONS: https://sethops1.net/post/run-freebsd-in-qemu-on-linux/
#  REQUIREMENTS: qemu FreeBSD qcow2 images ovmf(for UEFI bios)
#          BUGS: ---
#         NOTES: https://download.freebsd.org/releases/VM-IMAGES/14.2-RELEASE/amd64/Latest/
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 04/20/2025 03:55
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

basepath=/home/bhaskar/FreeBSD

cd $basepath || exit 1

sudo qemu-system-x86_64 -m 4096 -smp 5 -bios /usr/share/ovmf/OVMF.fd -serial mon:stdio -nographic -drive file=FreeBSD-14.2-RELEASE-amd64.qcow2 -enable-kvm

# To exit out of VM you should press these keys : CTRL-A x

# The -m 4096 option indicates the VM should have 4 gigabytes of system memory.

# The -smp 4 option indicates the VM should have 4 CPU cores.

# The -bios /usr/share/ovmf/OVMF.fd option indicates the VM should boot with UEFI.

# The -serial mon:stdio option indicates the VM should use your pseudo terminal as the serial terminal.

# The -nographic option indicates the VM should not have a display.

# The -drive <image> option indicates our VM image to boot.

# The -enable-kvm option indicates the VM should use Linux’s hardware acceleration.


# steps to follow for running FreeBSD in VM on Linux

# Get the qcow2 image
#
# wget -c  https://download.freebsd.org/releases/VM-IMAGES/14.2-RELEASE/amd64/Latest/FreeBSD-14.2-RELEASE-amd64.qcow2.xz
#

# Install ovmf and qemu-utils by your os package manager


# unxz to downloaded qcow2 image


# qemu-img resize [the downloaded qcow2 img file] +number of gigs to assisgn
# +14g

# Once booten into the vm ,do
# growfs / for expanding the filesystem