#!/bin/bash

#fetch and process memory information
[ -f /proc/meminfo ] && {
Buffers=`grep -we 'Buffers' /proc/meminfo | cut -d' ' -f2- | tr -d "[A-Z][a-z] "`
Cached=`grep -we 'Cached' /proc/meminfo | cut -d' ' -f2- | tr -d "[A-Z][a-z] "`
MemFree=`grep -ie 'MemFree' /proc/meminfo | cut -d' ' -f2- | tr -d "[A-Z][a-z] "`
MemTotal=`grep -ie 'MemTotal' /proc/meminfo | cut -d' ' -f2- | tr -d "[A-Z][a-z] "`
SwapCached=`grep -ie 'SwapCached' /proc/meminfo | cut -d' ' -f2- | tr -d "[A-Z][a-z] "`
SwapFree=`grep -ie 'SwapFree' /proc/meminfo | cut -d' ' -f2- | tr -d "[A-Z][a-z] "`
SwapTotal=`grep -ie 'SwapTotal' /proc/meminfo | cut -d' ' -f2- | tr -d "[A-Z][a-z] "`
}
MEMUSED="$(( ( ( ( $MemTotal - $MemFree ) - $Cached ) - $Buffers ) / 1024 ))"
MEMTOTAL="$(( $MemTotal / 1024))"
MEMFREE="$(( $MEMTOTAL - $MEMUSED ))"
MEMPER="$(( ( $MEMUSED * 100 ) / $MEMTOTAL ))"
[ "$SwapTotal" -gt "1" ] && {
  SWAPUSED="$(( ( ( $SwapTotal - $SwapFree ) - $SwapCached ) / 1024 ))"
    SWAPTOTAL="$(( $SwapTotal / 1024))"
      SWAPFREE="$(( $SWAPTOTAL - $SWAPUSED ))"
        SWAPPER="$(( ( $SWAPUSED * 100 ) / $SWAPTOTAL ))" 
	} || {
	  SWAPUSED="0"
	    SWAPTOTAL="0"
	      SWAPPER="0" 
	      }

	      # display the information
	      /bin/echo
	      /bin/echo "Memory"
	      /bin/echo "Used: $MEMUSED"
	      /bin/echo "Free: $MEMFREE"
	      /bin/echo "Total: $MEMTOTAL"
	      /bin/echo
	      /bin/echo "Swap"
	      /bin/echo "Used: $SWAPUSED"
	      /bin/echo "Free: $SWAPFREE"
	      /bin/echo "Total: $SWAPTOTAL"
	      /bin/echo

