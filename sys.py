#!/usr/bin/env python
import subprocess

#Note that Python is much more flexible with equal signs.  There can be spaces around equal signs.
MESSAGES = "pwd"
SPACE = "df -h"
KERNEL = "uname -a"
MEMORY = "free -m"

#Places variables into a list/array
cmds = [MESSAGES, SPACE, KERNEL,MEMORY]

#Iterates over list, running statements for each item in the list
#Note, that whitespace is absolutely critical and that a consistent indent must be maintained for the code to work properly
count=0
for cmd in cmds:
#    count+=1
#    print "This is  %s" % count
    subprocess.call(cmd, shell=True)
