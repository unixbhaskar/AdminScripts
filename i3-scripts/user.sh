#!/usr/bin/env bash

#!/bin/bash
i3status -c $HOME/.config/i3/i3status.conf | while :
do
	    read line
	        usr=`whoami`
		    echo "whoami: $line | $usr" || exit 1
	    done
