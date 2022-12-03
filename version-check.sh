#!/usr/bin/env bash

# This script will find and enlist essential and important tools

export LC_ALL=C
OS=$(uname -n)
arch=$(arch)

# Simple script to list version numbers of critical development tools

function version_check {
bash --version | head -n1 | cut -d" " -f2-4
echo "/bin/sh -> `readlink -f /bin/sh`"
echo -n "Binutils: "; ld --version | head -n1 | cut -d" " -f3-
bison --version | head -n1
flex --version | head -n1
if [ -e /usr/bin/yacc ];
  then echo "/usr/bin/yacc -> `readlink -f /usr/bin/yacc`";
    else echo "yacc not found"; fi
    bzip2 --version 2>&1 < /dev/null | head -n1 | cut -d" " -f1,6-
    echo -n "Coreutils: "; chown --version | head -n1 | cut -d")" -f2
    diff --version | head -n1
    find --version | head -n1
    gawk --version | head -n1
     ld --version | head -n1
    if [ -e /usr/bin/gawk ];
      then echo "/usr/bin/gawk -> `readlink -f /usr/bin/gawk`";
        else echo "awk not found"; fi
	gcc --version | head -n1
	/lib/libc.so.6 | head -n1 | cut -d"," -f1
	grep --version | head -n1
	gzip --version | head -n1
	cat /proc/version
	m4 --version | head -n1
	make --version | head -n1
	patch --version | head -n1
	echo Perl `perl -V:version`
	sed --version | head -n1
	tar --version | head -n1
	echo "Texinfo: `makeinfo --version | head -n1`"
	echo 'main(){}' > dummy.c && gcc -o dummy dummy.c
	if [ -x dummy ]; then echo "Compilation OK";
	  else echo "Compilation failed"; fi
	  rm -f dummy.c dummy

}

printf "This is running on this Architecture: $arch and on this Operating System: $OS \n"
printf "================================================================================= \n"
version_check
