#!/bin/bash -
#===============================================================================
#
#          FILE: build_nyxt_from_git_master_branch.sh
#
#         USAGE: ./build_nyxt_from_git_master_branch.sh
#
#   DESCRIPTION: Build nyxt from master git branch
#
#       OPTIONS:
#  REQUIREMENTS: asdf sbcl libfixposix
#          BUGS: ---
#         NOTES: Clone this repo git@github.com:atlas-engineer/nyxt.git
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 01/21/2022 12:47
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

basepath=/home/bhaskar/git-linux/

cd $basepath

if [ ! -d nyxt ];then
	git clone git@github.com:atlas-engineer/nyxt.git
	cd nyxt

elif [ -d nyxt ];then
       cd nyxt
# discard stuff from last build
      git reset --hard

# delete all of the last build stuff
      git clean -xdf

       git pull
else
	printf "The Nyxt directory already exists....not cloning \n"
	exit 1
fi

printf "Lets build it on.....$(hostname)"

make all



if [ $? -eq 0 ] ; then

	printf "Do you want to install system wide? [Y/N]: %s"
	read -r res

	if [ "$res" == "Y" ];then
		sudo make install
	else
		printf "Okay, you not want to install it system wide....not installing "
fi
fi