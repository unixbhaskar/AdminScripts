#!/bin/bash

#This is useful when a filename start with some uncanny character i.e underscore,hash,questionmark

ARGCOUNT=1 # filename must be passed to this script

E_WRONGARG=70

E_FILE_NOT_EXISTS=71

E_CHANGED_MIND=72

if [[ $# -ne "$ARGCOUNT" ]]
then
   echo "usage :`basename $0` filename"
   exit $E_WRONGARG
fi


if [[ ! -e "$1" ]]
then
   echo "File \""$1"\" does not exists."
   exit $E_FILE_NOT_EXISTS
fi

inum='ls -i | grep "$1" | awk `{ print $1 }` '

echo "The inode number for the file '$1' is `ls -i $1` "

#inum = index number of file
#Every file is associated with an inode number ,which signifies it's physical location 

echo;

echo -n "Are you absolutely sure you want to delete \"$1\" (y|n)?"
read answer

case "$answer" in

[nN]) echo "Change your mind?"
     exit $E_CHANGED_MIND
     ;;

 *)  echo "Deleting file \"$1\".... " ;;
esac

find . -inum $inum -exec rm {} \;

echo "File "\" $1"\" deleted!!"

exit 0





