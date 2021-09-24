#!/bin/bash -
#===============================================================================
#
#          FILE: emacs_build_from_source.sh
#
#         USAGE: ./emacs_build_from_source.sh
#
#   DESCRIPTION: Build Emacs from source
#
#       OPTIONS:
#  REQUIREMENTS:
#          BUGS: ---
#         NOTES: Clone this repo git://git.savannah.gnu.org/emacs.git
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 09/24/2021 17:37
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
basepath=/home/bhaskar/git-linux/

cd $basepath

if [ ! -d emacs ];then
	git clone git@git://git.savannah.gnu.org/emacs.git
	cd emacs

elif [ -d emacs ];then
       cd emacs
       git pull

else
	printf "The Vim directory already exists....not cloning \n"
	exit 1
fi

printf "Lets build it on.....$(hostname)"


./configure

make


if [ $? -eq 0 ] ; then

	printf "Do you want to install system wide? [Y/N]: %s"
	read -r res

	if [ "$res" == "Y" ];then
		sudo make install
	else
		printf "Okay, you not want to install it system wide....not installing "
fi
fi