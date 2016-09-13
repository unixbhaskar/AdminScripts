#!/bin/bash
#
# This script creates a new SVN repository. It requires the project name
# to be passed on the command line.
#
# The directory structure has been provided by quality with some small
# changes like the number of the top level directories done by me.
#
#
# What Who When
# ==== === ====
# Created initial script. W.H. 18-01-2007
#
#

# Define environment variables

svnurl='https://svn.naturesoft.net/svn/repos'
tmpdir=create-svn$(/bin/date +%s)
nicedate=$(/bin/date +%F)

function create-directories() {
mkdir "1.Initiating" && \
mkdir -p "2.Planning/VER[Verification_Process]" && \
mkdir "2.Planning/DDP[Detailed_Design_Process]" && \
mkdir "2.Planning/ADP[Architecture_Design_Process]" && \
mkdir "2.Planning/SRS[Software_Requirements_Specification]" && \
mkdir "2.Planning/Inbound" && \
mkdir "2.Planning/Outbound" && \
mkdir -p "3.Controlling" && \
mkdir "3.Controlling/Feedback" && \
mkdir "3.Controlling/MOM[Minutes_Of_Meetings]" && \
mkdir "3.Controlling/Metrics" && \
mkdir "3.Controlling/EVM[Earned_Value_Management]" && \
mkdir "3.Controlling/WSR[Weekly_Status_Reports]" && \
mkdir -p "4.Construction/Design" && \
mkdir -p "4.Construction/Source_Code/trunk" && \
mkdir "4.Construction/Source_Code/tags" && \
mkdir "4.Construction/Source_Code/branches" && \
mkdir "5.Closing"
}

if [ "$#" -eq 0 ]
then
echo "Please pass the repository name e.g. $0 customer-project"
exit 10
fi

mkdir -p /tmp/${tmpdir}/$1 && cd /tmp/${tmpdir}/$1
create-directories
cd /tmp/${tmpdir} && /usr/bin/svn import . ${svnurl} -m "${1} repository created, ${nicedate}"
cd && rm -r /tmp/${tmpdir}
echo
echo "NOTE : do not forget to set up the repository permissions in svnpolicy."
