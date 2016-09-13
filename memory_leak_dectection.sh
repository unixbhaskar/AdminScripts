#!/bin/bash
# track memory usage of sshd using pidstat and send report
# http://www.linuxsysadminblog.com - MaxV

export PID=/var/run/sshduse.pid
export TIMESTAMP=`date +%Y%m%d_%H%M%S`
export LOGDIR=/var/log/
export SSHD_LOG="${LOGDIR}sshd_memUsage_${TIMESTAMP}"
export SSHD_PID=`cat /var/run/sshd.pid`
export MAILTO=user@domain.com

if [ ! -e ${PID} ]; then

#create pid file
echo $$ > ${PID}

#log begin of script to /var/log/messages
/usr/bin/logger "Starting SSHD Memory Usage Tracker"

# pidstat portion, poll 12 times with 5 minutes apart
/usr/bin/pidstat -r -p ${SSHD_PID} 300 12 >> ${SSHD_LOG}

#e-mail report
mail -s "SSHD memory usage ${TIMESTAMP}" ${MAILTO} < ${SSHD_LOG}

#clean up pid file
if [ -f ${PID} ]; then
rm -rf ${PID}

#log end of script to /var/log/messages
/usr/bin/logger "Ending SSHD Memory Usage Tracker"
fi
exit 0
else

exit 0
fi
