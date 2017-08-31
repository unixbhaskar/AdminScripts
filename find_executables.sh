#!/bin/bash
 
 IFS=:
  
  for dir in $PATH
   
   do
    
    echo "$dir:"
     
     for myfile in $dir/*
      
      do
       
       if [ -x $myfile ]
        
	then
	 
	 echo " $myfile"
	  
	  fi
	   
	   done
	    
	    done
