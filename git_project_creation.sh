#!/bin/bash
# This script will crate git project in specified location,only need to pass the name of the porject.


if [ $# -ne 1 ] ; then
  echo "Usage : $0 <project name>"
  exit 2
fi

ProjectName=$1

basedir="/home/$USER/git-linux/"

mkdir -p  $basedir/${ProjectName}

chown -R $USER:$USER $basedir/${ProjectName}

cd $basedir/${ProjectName}
git init  --bare && git init

git add . && git commit -s  -m "intial commit"
exit 0
