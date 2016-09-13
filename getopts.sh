 #!/bin/bash
# this script will take command line argument for anythign mentioned below in case statement plus a catch all opetion.
echo -n " Enter the valid thing : "
read options
 while getopts ":u:a:s:v" options; do
   case $options in
       u ) uname=$OPTARG;; # user name
       a ) attrs=$OPTARG;; # attributes
       s ) searchattr=$OPTARG;; # search attributes
       v ) att=ALL;;       # verbose 
       h ) echo $usage;;   # spit out the thing how to use properly
      \? ) echo $usage     # spit out the theing how to use properly
  exit 1;;
   * ) echo $usage         # catch all thing
  exit 1;;
esac
done
