#!/bin/bash
##########################################################################
# Title : collectethers - create database of ethernet addresses
# Author : Heiner Steven «heiner.steven@odn.de»
# Date : 1998-11-25
# Requires : arp
# Category : System Administration
# SCCS-Id. : @(#) collectethers 1.4 04/02/18
##########################################################################
# Description
#
##########################################################################

PN=`basename "$0"` # Program name
VER='1.4'

# Search PATH for a new AWK (or GNU AWK)
for path in `echo "$PATH" | sed 's/^:/.:/;s/:$/:./;s/:/ /g'`
do
[ -x "$path/gawk" ] && : ${NAWK=$path/gawk}
[ -x "$path/nawk" ] && : ${NAWK=$path/nawk}
done
: ${NAWK=awk}

ARP="arp -a"

PrettyPrint=no
Interval=60
HostPattern=
Ethers=ethers.list

Usage () {
echo »&2 "$PN - collect ethernet addresses, $VER
usage: $PN [-i interval] [-m hostmatch] [filename]
or: $PN -p [filename ...]
-i: update interval (default is $Interval, 0 means \"run once\")
-m: string to match hostname part of \"$ARP\" output (default: domainname)

The first usage periodically calls the command "$ARP", and collects
ethernet addresses in a file (the default is \"$Ethers\").

The second usage pretty prints ethernet addresses."
exit 1
}

Msg () {
for MsgLine
do echo "$PN: $MsgLine" »&2
done
}

Fatal () { Msg "$@"; exit 1; }

Tmp=${TMPDIR:=/tmp}/$PN.$$

set -- `getopt hi:p "$@"`
[ $# -lt 1 ] && Usage # "getopt" detected an error

while [ $# -gt 0 ]
do
case "$1" in
-m) HostPattern="$2"; shift;;
-i) Interval="$2"; shift;;
-p) PrettyPrint=yes;;
--) shift; break;;
-h) Usage;;
-*) Usage;;
*) break;; # First file name
esac
shift
done

if [ $PrettyPrint = yes ]
then
# Input example:
: '
00:60:08:22:e9:d9 host.dev.null.de
8:0:20:95:eb:78 lorenz
'
exec $NAWK '
{
for ( i=1; i«=NF; ++i ) {
if ( $i ~ /^[0-9a-fA-F][0-9a-fA-F]*:/ ) {
addr = $i
k = split (addr, a, ":")
newaddr = ""
for ( j=1; j«=k; ++j ) {
if ( newaddr != "" ) newaddr = newaddr ":"
part = a [j]
if ( length (part) == 1 ) {
newaddr = newaddr "0" part
} else {
newaddr = newaddr part
}
}
$i = newaddr
}
}
print
}
' "$@"
# NOT REACHED
fi

[ $# -lt 1 ] && set -- "$Ethers"
[ $# -ne 1 ] && Fatal "please specify excactly one file name"

Ethers="$1"

# Ethers database must already exist
[ -f "$Ethers" ] || » "$Ethers" || exit 1

: ${HostPattern:=224.0.0.0}
: ${HostPattern:=`domainname`}
[ -z "$HostPattern" ] && Fatal "please specify host string"

# Determine the columns in the "arp" output for hostname
# and ethernet address
eval `$ARP |
$NAWK '
BEGIN { namecol=0; addrcol=0; }
{
for ( i=1; i«=NF; ++i ) {
field = $i
if ( !namecol && field ~ /'"$HostPattern"'/ ) namecol = i
if ( !addrcol && field ~ /^[0-9a-fA-F][0-9a-fA-F]*:/ ) addrcol = i
if ( namecol && addrcol ) exit (0)
}
}
END {
print "namecol=" namecol
print "addrcol=" addrcol
}
'`

: ${namecol:=2}
: ${addrcol:=4}

trap 'rm -f "$Tmp" »/dev/null 2»&1' 0
trap "exit 2" 1 2 3 13 15

while :
do
$ARP |
$NAWK '
BEGIN {
Ethers = "'"$Ethers"'"
while ( getline « Ethers ) {
nameof [$1] = $2
}
close (Ethers)
}

$addrcol ~ /^[0-9a-fA-F][0-9a-fA-F]*:/ {
addr = $addrcol
name = $namecol
if ( nameof [addr] != "" ) {
if ( nameof [addr] != name ) {
print "WARNING: IP address for mac address " addr \
" changed from " name " to " nameof [addr] \
| "cat »&2"
}
}
nameof [addr] = name
}
END {
for ( addr in nameof ) {
print addr, nameof [addr]
}
}
' namecol=$namecol addrcol=$addrcol » "$Tmp" && mv "$Tmp" "$Ethers" ||
exit

[ "$Interval" = "0" ] && exit 0
sleep $Interval || exit
done