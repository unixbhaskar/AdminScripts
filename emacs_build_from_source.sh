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
	git clone git://git.savannah.gnu.org/emacs.git
	cd emacs

elif [ -d emacs ];then
       cd emacs
# discard stuff from last build
      git reset --hard

# delete all of the last build stuff
      git clean -xdf

       git pull
else
	printf "The Emacs directory already exists....not cloning \n"
	exit 1
fi

printf "Lets build it on.....$(hostname)"

./autogen.sh
# ./configure --with-pgtk
# ./configure --with-gnutls=ifavailable --with-native-compilation --with-libxml2

./configure --with-x --with-x-toolkit=gtk3 --without-toolkit-scroll-bars --with-cairo --without-xft --with-harfbuzz --without-libotf --with-gnutls --without-xdbe --without-xim --without-gpm --disable-gc-mark-trace --with-gsettings --with-modules --with-threads --with-libgmp --with-xml2 --with-tree-sitter --with-zlib --without-included-regex --with-native-compilation --with-file-notification=inotify --without-compress-install

make -j "$(nproc)" -l "$(nproc --ignore=1)"


if [ $? -eq 0 ] ; then

	printf "Do you want to install system wide? [Y/N]: %s"
	read -r res

	if [ "$res" == "Y" ];then
		sudo mv /usr/bin/emacs{,.$(date +'%F%T')}
		sudo make install-strip
		sudo cp /usr/local/bin/emacs /usr/bin/


	else
		printf "Okay, you not want to install it system wide....not installing "
fi
fi