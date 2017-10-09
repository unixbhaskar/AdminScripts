#!/bin/bash 
echo "Name the directory ,you want to search:"
echo
read directory

echo "Please enter the date manually(in this format YYYY-mon-date):"
echo
read DATE

echo "....okay searching...please wait...."
echo


find ${directory} -type f -newermt ${DATE} -ls
