#!/usr/bin/env python
import stat, sys, os, string, commands

#Getting search pattern from user and assigning it to a list

try:
    #run a 'find' command and assign results to a variable
    pattern = raw_input("Enter the file pattern to search for:\n")
    commandString = "find " + pattern
    commandOutput = commands.getoutput(commandString)
    findResults = string.split(commandOutput, "\n")

    #output find results, along with permissions
    print "Files:"
    print commandOutput
    print "================================"
    for file in findResults:
        mode=stat.S_IMODE(os.lstat(file)[stat.ST_MODE])
        print "\nPermissions for file ", file, ":"
        for level in "USR", "GRP", "OTH":
            for perm in "R", "W", "X":
                if mode & getattr(stat,"S_I"+perm+level):
                    print level, " has ", perm, " permission"
                else:
                    print level, " does NOT have ", perm, " permission"
except:
    print "There was a problem - check the message above"

