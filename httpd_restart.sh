#!/bin/bash

sfile=/run/httpd/httpd.pid
TO_MAIL=bhaskar.chowdhury@heymath.com

if [ -f "${sfile}" ]; then
   old_count=`cat /run/httpd/httpd.pid`
else
   old_count='0'
fi

new_count=`ps -ef | grep httpd | wc -l `

#echo $new_count > $sfile

if [ "${new_count}" -ne "0" ] && [ "${old_count}" -ne "${new_count}" ]; then
        service httpd restart
echo $?
   echo "apache fault detected , httpd restarted" | mail -s "httpd restarted" $TO_MAIL
fi

exit 0
