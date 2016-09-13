#!/bin/bash

DIR=$1

if [ !-d $DIR ] ; then

echo "Want to create the dir ? please pass the name here :"
read dirname

mkdir -p $dirname

/usr/bin/namei $dirname

exit 1;

fi

cd $dirname

for n in $(seq 1 52); do touch $dirname/$n;done

echo $?

ls -al $dirname | wc -l

