#!/bin/bash
#
# Bill Beavis
#
#  todo:  better checking for commandline arguments

CLIMIT=80
WLIMIT=50
STATE_OK=0
STATE_CRITICAL=2
STATE_WARNING=1

print_help() {
	echo ""
	echo "Usage: check_top_process -w <warning> -c <critical>"
	echo ""
	echo "This plugin checks the top running process."
	echo ""
	exit 0
}

case "$1" in
	-w)
		WLIMIT=$2
		CLIMIT=$4
		;;
	-c)
		CLIMIT=$2
		WLIMIT=$4
		;;
	--help)
		print_help
		exit $STATE_OK
		;;
	-h)
		print_help
		exit $STATE_OK
		;;
	*)
esac

if [ `echo $WLIMIT $CLIMIT |awk '{print ($1 > $2)  ? "true" : "false" }'` = "true" ]
then
	echo "Error: WARNING value must be below CRITICAL value"
	print_help
	exit $STATE_OK
fi


x=`UNIX95= ps -eo pcpu,comm,user,pid,time |sort -rnk1 | head -1`
y=`echo $x |awk '{print $1 "% command=" $2 " user=" $3 " pid=" $4 " cputime=" $5}'`
if [ `echo $x $CLIMIT |awk '{print ($1 > $6)  ? "true" : "false" }'` = "true" ]
then
	echo $y
	exit $STATE_CRITICAL
fi

if [ `echo $x $WLIMIT |awk '{print ($1 > $6)  ? "true" : "false" }'` = "true" ]
then
	echo $y
	exit $STATE_WARNING
fi

echo $y
exit $STATE_OK
