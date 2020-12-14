#!/bin/bash -
#===============================================================================
#
#          FILE: backup_to_external_hdd.sh
#
#         USAGE: backup_to_external_hdd.sh
#
#   DESCRIPTION: This script will perform an backup to certain directory ,tar zipped to external HDD.
#
#       OPTIONS: ---
#  REQUIREMENTS: cryptsetup tar mount
#          BUGS: ---
#         NOTES: Static variable values for few variables
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 05/08/2020 13:13
#      REVISION:  1.0
#===============================================================================

set -o nounset                              # Treat unset variables as an error

if [[ $UID -ne 0 ]];then
 printf "Without superuser power you can not run this scipt.\n"
 exit 1
fi

crypt=$(command -v cryptsetup)
external_drive=$(fdisk -l | grep sdb | gawk '{ print $2 }' | tr -d :)
bkup2="/backup2"
tar=$(command -v tar)
home_backupfile="home-backup-$(date +'%F').tar.gz"
data_backupfile="data-backup-$(date +'%F').tar.gz"
default_backup_lvm="/dev/mapper/backup2"


#Actaual meat of the script , which might be converted to a function ,later task.

if [[ $external_drive != "" ]];then
       mkdir -p $bkup2
	$crypt luksOpen $external_drive $bkup2
	#need to put your passphrase on the stdin
	mount $default_backup_lvm $bkup2

        printf "Check status and dump of the luks device.....\n\n"
	$crypt luksDump $external_drive
	sleep 2
	$crypt -v status $bkup2

	 printf "\n\n Time to take backup ...hold on ....it will take sometime ...\n\n"

	cd $bkup2

printf "Checking that we are in correct dir : $(pwd) \n\n"

	home_backup=$($tar --exclude="/home/bhaskar/git-linux" --exclude="/home/bhaskar/Pictures" --exclude="/home/bhaskar/Music"  -cvzf $home_backupfile /home/bhaskar)


	eval $home_backup

	printf "\n Executing this : tar -czf $data_backupfile /data \n\n"

	data_backup=$($tar  --exclude="/data/linux" --exclude="/data/asp" --exclude="/data/firefox_log" -cvzf $data_backupfile /data)
	eval $data_backup

	printf "\n\n Checkout their existence ...\n\n"

	find . -name "home-backup-*" -type f -print0 -exec ls -al {} \;
	find . -name "data-backup-*" -type f -print0 -exec ls -al {} \;

         printf "\n\nShould I close this connection[Y/N]: %s"
	 read_response

	 if [[ $read_response == "Y" ]];then

	  umount /backup2
	  $crypt luksClose $bkup2

	else

	 continue
fi

else
	printf "Device not mounted"
	exit 1
fi




