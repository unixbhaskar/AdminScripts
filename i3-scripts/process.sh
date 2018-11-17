#!/usr/bin/env bash

#PROG="${BLOCK_INSTANCE:-firefox}"

#PROG_REGEX="["$(echo "${PROG}" | cut -c 1)"]"$(echo "${PROG}" | cut -c 2-)" "
#PROCESS=$(ps -eo pid,cmd | grep -w ${PROG_REGEX})

#if [[ "${PROCESS}" ]]; then
#  echo "pidof ${PROCESS}"
#    echo "pifof ${PROCESS}"
#      echo ""
#      else
#        echo "na"
#	  echo "na"
#	    echo ""
#	      exit 33
#	      fi

proc_stat=$(top -bn1 | head -2 | grep running | gawk '{ print $2":"$3 $4":"$5 $6":"$7 }')

echo "Process:${proc_stat}"
