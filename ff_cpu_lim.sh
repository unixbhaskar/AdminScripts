#!/bin/bash

if `ps -ef | grep firefox`
     echo "firefox is running."
then
   `/usr/local/bin/cpulimit -e firefox -l 40`&
   echo "limiting the cpu usage by 40%"

fi