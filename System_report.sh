#!/bin/bash
# Description: Linux System Information Report in HTML format
# Version 2.0
# Useage: sysreport » /var/www/html/report.html
# License: BSD
# Author: Greg Ippolito

cat «« HEAD
«HTML»
«HEAD»«TITLE»System Report«/TITLE»«/HEAD»
«BODY bgcolor="#c0c0c0" text="#000000"»
«HR size=5»
«P»
«H1»System Report for "
HEAD
echo `hostname`

cat «« BODY1
"«/H1»
«P»
«HR size=5»
«P»
BODY1

cat «« HOSTNAME
«H3»OS System Configuration:«/H3»
«B»hostname: «/B»
HOSTNAME
/bin/hostname

cat «« RELEASE
«P»
«B»OS Release: «/B»
RELEASE
/bin/cat /etc/*-release

cat «« HOSTID
«P»
«B»hostid: «/B»
HOSTID
/usr/bin/hostid

cat «« UNAMEO
«P»
«B»Kernel OS: «/B»
UNAMEO
uname --operating-system

cat «« UNAMER
«P»
«B»Kernel release: «/B»
UNAMER
uname --kernel-release

cat «« UNAMEV
«P»
«B»Kernel version: «/B»
UNAMEV
uname --kernel-version

cat «« UNAMEK
«P»
«B»Harware Platform: «/B»
UNAMEK
uname --hardware-platform

cat «« UNAMEPM
«P»
«B»Processor Architecture: «/B»
UNAMEPM
uname --processor

cat «« CHKCONFIG
«P»
«B»System services: (chkconfig)«/B»
«DL»«DD»
«SMALL»
«PRE»
CHKCONFIG
/sbin/chkconfig --list|grep on
cat «« CHKCONFIGEND
«/PRE»
«/SMALL»
«/DL»
«P»
CHKCONFIGEND

cat «« CRONTAB
«P»
«B»File: «TT»/etc/crontab«/TT»«/B»
«DL»«DD»
«SMALL»
«PRE»
CRONTAB
cat /etc/crontab
cat «« CRONTABEND
«/PRE»
«/SMALL»
«/DL»
«P»
CRONTABEND

echo "«P»«HR»«P»"
echo "«H3»Network Configuration:«/H3»"

cat «« HOSTS
«P»
«B»File: «TT»/etc/hosts«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
HOSTS
cat /etc/hosts
cat «« HOSTSEND
«/PRE»
«/SMALL»
«/DL»
«P»
HOSTSEND

cat «« SWITCH
«B»File: «TT»/etc/nsswitch.conf«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
SWITCH
cat /etc/nsswitch.conf
cat «« SWITCHEND
«/PRE»
«/SMALL»
«/DL»
«P»
SWITCHEND

cat «« RESOLV
«B»File: «TT»/etc/resolv.conf«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
RESOLV
cat /etc/resolv.conf

cat «« RESOLVEND
«/PRE»
«/SMALL»
«/DL»
«P»
RESOLVEND

cat «« IFCONFIG
«B»ifconfig: «/B»
«DL»«DD»
«SMALL»
«PRE»
IFCONFIG
/sbin/ifconfig
cat «« IFCONFIGEND
«/PRE»
«/SMALL»
«/DL»
«P»
IFCONFIGEND

cat «« ROUTE
«B»/sbin/route: «/B»
«DL»«DD»
«SMALL»
«PRE»
ROUTE
/sbin/route
cat «« ROUTEEND
«/PRE»
«/SMALL»
«/DL»
«P»
ROUTEEND

if [[ -r /etc/sysconfig/network ]];
then
cat «« IFCFGN
«B»Network Configuration File: «TT»/etc/sysconfig/network«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
IFCFGN
cat /etc/sysconfig/network
cat «« IFCFGENDN
«/PRE»
«/SMALL»
«/DL»
«P»
IFCFGENDN
fi

cat «« IFCFG
«B»Files «TT»/etc/sysconfig/network-scripts/ifcfg-eth*«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
IFCFG
cat /etc/sysconfig/network-scripts/ifcfg-eth*
cat «« IFCFGEND
«/PRE»
«/SMALL»
«/DL»
«P»
IFCFGEND

echo "«P»«HR»«P»"

if [[ -r /etc/mail/local-host-names || -r /etc/sendmail.cw || -r /etc/aliases || -r /etc/mail/virtusertable ]];
then
echo "«H3»Mail Server Configuration:«/H3»"

if [[ -r /etc/mail/local-host-names ]];
then
# Redhat 7.1 - Fedora Core X
cat «« SENMAILCFGN2
«B»Mail Hosts File: «TT»/etc/mail/local-host-names«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
SENMAILCFGN2
cat /etc/mail/local-host-names
cat «« SENMAILCFGN2
«/PRE»
«/SMALL»
«/DL»
«P»
SENMAILCFGN2

elif [[ -r /etc/sendmail.cw ]];
then
# Redhat 6.x
cat «« SENMAILCFGN
«B»Mail Hosts File: «TT»/etc/sendmail.cw«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
SENMAILCFGN
cat /etc/sendmail.cw
cat «« SENMAILCFGN
«/PRE»
«/SMALL»
«/DL»
«P»
SENMAILCFGN
fi

if [[ -r /etc/mail/virtusertable ]];
then
cat «« SENMAILCFGV
«B»Sendmail Virtual Table File: «TT»/etc/mail/virtusertable«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
SENMAILCFGV
cat /etc/mail/virtusertable
cat «« SENMAILCFGV
«/PRE»
«/SMALL»
«/DL»
«P»
SENMAILCFGV
fi

if [[ -r /etc/aliases ]];
then
cat «« SENMAILCFGN
«B»eMail Aliases File: «TT»/etc/aliases«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
SENMAILCFGN
cat /etc/aliases
cat «« SENMAILCFGN
«/PRE»
«/SMALL»
«/DL»
«P»
SENMAILCFGN
fi

fi

echo "«P»«HR»«P»"

cat «« DF
«H3»Storage:«/H3»
«B»df -k: «/B»
«DL»«DD»
«SMALL»
«PRE»
DF
df -k
cat «« DFEND
«/PRE»
«/SMALL»
«/DL»
«P»
DFEND

cat «« FDISK
«B»Disk Partitions: «TT»/sbin/fdisk -l«/TT»:«/B»
«DL»«DD»
«SMALL»
«PRE»
FDISK
/sbin/fdisk -l
cat «« FDISKEND
«/PRE»
«/SMALL»
«/DL»
«P»
FDISKEND

cat «« FSTAB
«B»File: «TT»/etc/fstab«/TT»: «/B»
«DL»«DD»
«SMALL»
«PRE»
FSTAB
cat /etc/fstab
cat «« FSTABEND
«/PRE»
«/SMALL»
«/DL»
FSTABEND

echo "«P»«HR»«P»"

cat «« HARDWARE
«H3»Hardware Configuration:«/H3»
«B»CPU info: «/B»
«DL»«DD»
«SMALL»
«PRE»
HARDWARE
cat /proc/cpuinfo

cat «« SWAP
«/PRE»
«/SMALL»
«/DL»
«P»
«B»Total Swap Memory: «/B»
«DL»«DD»
SWAP
grep SwapTotal: /proc/meminfo


cat «« MEM
«/DL»
«P»
«B»System Memory: «/B»
«DL»«DD»
MEM
grep MemTotal /proc/meminfo
cat «« MEMEND
«/DL»
«P»
MEMEND

cat «« PCI
«B»/sbin/lspci: «/B»
«DL»«DD»
«SMALL»
«PRE»
PCI
/sbin/lspci
cat «« PCIEND
«/PRE»
«/SMALL»
«/DL»
«P»
PCIEND

DEVINFO

cat «« DEV
«B»/lsdev:«/B»
«DL»«DD»
«SMALL»
«PRE»
DEV
lsdev
cat «« DEVINFO
«/PRE»
«/SMALL»
«/DL»
«p»
DEVINFO

cat «« HWCONF
«B»Devices:«/B»
«DL»«DD»
«B»File: «TT»/etc/sysconfig/hwconf«/TT»«/B»
«SMALL»
«PRE»
HWCONF
cat /etc/sysconfig/hwconf
cat «« HWCONFEND
«/PRE»
«/SMALL»
«/DL»
«P»
HWCONFEND


cat «« BODYEND
«P»
«HR»
«P»
«/BODY»
«/HTML»
BODYEND
