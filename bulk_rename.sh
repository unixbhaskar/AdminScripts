 #!/bin/bash

 for f in $1   # put file extension here such as *.txt,.....

 do

 cp -v $f{,.orig}; # here we move the old extension to new one i.e .txt to .sh etc

 done ;
