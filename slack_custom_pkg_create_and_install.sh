#!/usr/bin/env bash
#===============================================================================
#
#          FILE: slack_custom_pkg_install.sh
#
#         USAGE: slack_custom_pkg_create_and_install.sh  "url" "package name" "version"
#
#   DESCRIPTION: Build a custom Slackware package
#
#       OPTIONS: Need to provide the target software download url,name and version as an argument.
#  REQUIREMENTS: tar gzip xz bunzip makepkg
#          BUGS:
#         NOTES: Customized version of the Slackware package management.
#        AUTHOR: Bhaskar Chowdhury (https://about.me/unixbhaskar), unixbhaskar@gmail.com
#  ORGANIZATION: Independent
#       CREATED: 05/13/2022 10:27
#      REVISION:  1.0
#===============================================================================\
set -vx
url=$1
basepath=$HOME/slackware_custom_package
pkg_name=$2
pkg_ver=$3
arch=$(uname -m)
build_dir=$basepath/$dir_name
mkpkg="/sbin/makepkg -l y -c n"
instpkg="/sbin/installpkg"
slpkg="/usr/sbin/slackpkg"

# File system to hold the new package stuff

echo Build basic file stucture for the new package creation
echo

mkdir -p "$basepath"/{build,install}
touch "$basepath/install/slack-desc"

 cat <<EOF  >$basepath/install/slack-desc
	 $pkg_name: $pkg_name \(Short/Brief description\)
	 $pkg_name:
	 $pkg_name: Enter a description of the package you are building.
	 $pkg_name:
	 $pkg_name:
	 $pkg_name:
	 $pkg_name:
	 $pkg_name:
	 $pkg_name:
	 $pkg_name:
	 $pkg_name:
EOF


cd "$basepath" || exit

usage(){

	echo You are suppose to provide three argumenrs: url,name and version
	echo
	echo $(basename $0) \"url\" \"name\" \"version\"
        echo
	echo Also, do not forget to enter some metadata about the package
	echo In the $basepath/install/slack-desc file\;like below
	echo
	echo app: Application Name \(Short/Brief description\)
	echo app:
	echo app: Enter a description of the package you are building.
	echo app: All 11 "app:" lines must be present
	echo app: "app" needs to be your application name.
	echo app: The handy-ruler is there to help you, these lines should not exceed
	echo app: 79 characters.
	echo app:
	echo app:
	echo app:
	echo app:
	echo This script will prompt you to enter these details,essentially open an editor
}


if [[ $# -ne 3 ]];then
	usage
	exit 1
fi


# Fetch the software

echo Downloading.......
echo

wget "$url"


# Gather stats about this package build

echo This package is building on $arch and the name of the package is $pkg_name \
	and the version is $pkg_ver

echo
echo Extracting ........
echo

 archive=$(find . -name "*.tar.*" -type f)
    if [[ "$archive" == *.tar.gz ]]; then
        $(command -v tar) -xvzf $archive
    elif [[ "$archive" == *.tar.xz ]]; then
        $(command -v tar) -xJvf $archive
    elif [[ "$archive" == *.tar.bz2 ]]; then
        $(command -v tar) -xjvf $archive
    elif [[ "$archive" == *.tar.zst ]]; then
        $(command -v tar) -zstd $archive
    elif [[ "$archive" == *.tgz ]]; then
        $(command -v tar) -xvzf  $archive
    elif [[ "$archive" == *.tbz2 ]]; then
        $(command -v tar) -xvzf $archive
    else
        echo "Error: Unsupported archive format. Supported: .tar.gz, .tar.xz, .tar.bz2, .tar.zst, .tgz, .tbz2"
        return 1
    fi

# dir name
    if [[ "$archive" == *.tar.gz ]]; then
        dir_name="${archive%.tar.gz}"  # Remove .tar.gz suffix
    elif [[ "$archive" == *.tar.xz ]]; then
        dir_name="${archive%.tar.xz}"  # Remove .tar.xz suffix
    elif [[ "$archive" == *.tar.bz2 ]]; then
        dir_name="${archive%.tar.bz2}" # Remove .tar.bz2 suffix
    elif [[ "$archive" == *.tar.zst ]]; then
        dir_name="${archive%.tar.zst}" # Remove .tar.zst suffix
    elif [[ "$archive" == *.tgz ]]; then
        dir_name="${archive%.tgz}"     # Remove .tgz suffix
    elif [[ "$archive" == *.tbz2 ]]; then
        dir_name="${archive%.tbz2}"    # Remove .tbz2 suffix
    else
        echo "Error: Unsupported archive format. Supported: .tar.gz, .tar.xz, .tar.bz2, .tar.zst, .tgz, .tbz2"
        return 1
    fi
cd "$dir_name" || exit

# make build of the software

build() {


echo Hang on! We are building it .........
       if test -f configure;then
         ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc

	make

       make install DESTDIR="$build_dir/build"

      elif test -f "meson.build";then
	 meson setup build
	 ninja -C build
	 ninja -C build install
         make install DESTDIR="$build_dir/build"


      else

	     echo "poor construction"

       fi

# strip off unnecessary things

       # strip -s  $basepath/build/usr/bin/*
       # strip -s $basepath/build/usr/lib/* $basepath/build/usr/libexec/* $basepath/build/usr/bin/*

# Gizzped the man pages

      # gzip -9 $basepath/build/usr/man/man?/*.?
}

# Before making the actual package, put some metadata in designated file


$(command -v vim) $basepath/install/slack-desc

# It could be other editor of choice
# $(command -v emacs) -nw /install/slack-desc


# make package

package()
{
        echo Making package of the built software......

        sh -c "/sbin/makepkg -l y -c n "$pkg_name"_"$pkg_ver"_$arch.tgz"


        echo Installing........

              sudo  sh -c ""$instpkg" "$pkg_name"_"$pkg_ver"_$arch.tgz"

	echo Show installed package info......

	 "$slpkg" info "$pkg_name"
}

build
package
