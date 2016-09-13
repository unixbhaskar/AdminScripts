 #!/bin/bash -xv

 select options in "apache2" "named" "postfix" "vnstatd" "syslog-ng" "sysstat" "nagios" "sshd" "mysql" "clamd" "puppet" "ntpd" "puppetmaster" 

 do

 echo "***********************"

 case $options in

 apache2 | httpd) /etc/init.d/apache2 status ;;

 named) /etc/init.d/named status;;

 postfix)/etc/init.d/postfix status;;

 sysstat)/etc/init.d/sysstat status;;

 syslog-ng)/etc/init.d/syslog-ng status;;

 vnstatd)/etc/init.d/vnstatd status;;

 nagios)/etc/init.d/nagios status;;

 sshd)/etc/init.d/sshd status;;

 mysql)/etc/init.d/mysql status;;

 clamd)/etc/init.d/clamd status;;

 puppet)/etc/init.d/puppet status;;

 puppetmaster)/etc/init.d/puppetmaster status;;

 ntpd)/etc/init.d/ntpd status;;

 *) echo "Nothing will be restarted"

 esac

 echo "***********************"

 break

 # If this break is not there then we wont get a shell prompt

 done
