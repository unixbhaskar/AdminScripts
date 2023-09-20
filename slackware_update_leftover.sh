#!/usr/bin/env bash
#===============================================================================
#
#          FILE: slackware_update_leftover.sh
#
#         USAGE: ./slackware_update_leftover.sh
#
#   DESCRIPTION: Clean things up after the update by putting files in  places
#
#       OPTIONS: ---
#  REQUIREMENTS: --- GNU coreutils
#          BUGS: ---
#         NOTES: --- Cleanliness of the /etc directory
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 09/19/2023 05:37
#      REVISION:  ---
#===============================================================================

# License (GPL v2.0)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

set -o nounset                              # Treat unset variables as an error


usage(){

   echo You are suppose to be Superuser to run this script.
   exit 1
}

# You are suppose to be root to be run this script otherwise fail.

if test  $UID -ne 0;then
	usage
fi

# Specific naming format for the newly created directories

backup_dir_with_new_extension="/etc/backup_new_config_$(date +'%F_%T')"
backup_dir_with_orig_extension="/etc/backup_orig_config_$(date +'%F_%T')"
search_dir=/etc
TAR="$(command -v tar)"
old_backup_dir1=$(find . -name "backup_new_config_*" -type d | tr -d "./")
old_backup_dir2=$(find . -name "backup_orig_config_*" -type d | tr -d "./")


cd "$search_dir" || exit 1

# Function to make a tarball of the existing directory filled with dot new
# extensions files and create a new directory to hold new files left the by
# updates.

config_backedup_with_new(){

	 files=$(find "${search_dir}" -name "*.new" -type f -print)

	sh -c "\"${TAR}\" -czf previous_new_config.tar.gz \"${old_backup_dir1}\""
	mkdir -p "${backup_dir_with_new_extension}"

	for i in $files
do
	ls -l "$i"
	mv -v "$i" "${backup_dir_with_new_extension}"
done
}


# Function to make a tarball of the existing directory filled with dot orig
# file extensions and create new directory to hold new dot orig files left by
# the update

config_backedup_with_orig(){

        files=$(find "${search_dir}" -name "*.orig" -type f -print)

       sh -c "\"${TAR}\" -czf  previous_orig_config.tar.gz \"${old_backup_dir2}\""
	mkdir -p "${backup_dir_with_orig_extension}"

       for i in $files
do
	ls -l "$i"
	mv -v "$i" "${backup_dir_with_orig_extension}"
done
}

# Checking if calling the commands for the job is successful or not.
if test "$(config_backedup_with_new)" -eq 0;then

	echo Moved new extensions files successfully!
else
	echo Bloody hell...check manually
fi

if test "$(config_backedup_with_orig)" -eq 0;then

	echo Moved orig extentions files successfully!
else
	echo Bloody hell ....check manually
fi
