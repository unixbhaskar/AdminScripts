#!/bin/bash -
#===============================================================================
#
#          FILE: vim_build_from_source.sh
#
#         USAGE: ./vim_build_from_source.sh
#
#   DESCRIPTION: Build Vim from source
#
#       OPTIONS: System clipboard copy needs gui build too.
#  REQUIREMENTS:
#          BUGS: ---
#         NOTES: Clone this repo git@github.com:vim/vim.git
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 09/24/2021 17:37
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
basepath=/home/bhaskar/git-linux/

printf "Hang on! Lets take a backup of existing files and folders first
.....\n"

sudo mv /usr/bin/vim{,.$(date +'%F_%T')}
#sudo mv /usr/share/vim{,.$(date +'%F_%T')}

if [[ $? -eq 0 ]];then
	echo Done!
else
	echo Not backed up properly...so aborting
	exit 1
fi

cd $basepath

if [ ! -d vim ];then
	git clone git@github.com:vim/vim.git
	cd vim

elif [ -d vim ];then
	cd vim
	git pull

else
	printf "The Vim directory already exists....and updated...not cloning \n"
	exit 1
fi

printf "Lets build it on.....$(hostname)"

make clean

./configure  --with-features=huge --enable-rubyinterp ---enable-pythoninterp --with-python-config-dir=$(python3-config --configdir) --enable-perlinterp --enable-gui=gtk2 --enable-cscope --enable-luainter  --enable-multibyte --prefix=/usr

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
