#!/bin/bash

#This is an absolutely mundane script to kick off jenkins


#Variable declaration for conveniance,standard place,you can change as per your requirement.
LOGFILE=/var/log/jenkins/jenkins.log
WARFILE=/opt/jenkins/jenkins.war

#Empty out the previous logs, might not useful for production system
>$LOGFILE


printf "Sarting Jenkins CI/CD server on `hostname` and on `date` ....."
printf "\n"

#Creating a function to invoke jenkins war file from specified directory.

jenkins_server() {
/usr/bin/java -jar $WARFILE > $LOGFILE 2>&1
exit 0
}

#Calling the function to start the service.

jenkins_server&

#Informational messeages to know status of the daemon.

printf "Check the daemon status from log file for confirmation..."
printf "\n"

sleep 20

grep "INFO: Jenkins is fully up and running" $LOGFILE 

printf "Done. \n"



