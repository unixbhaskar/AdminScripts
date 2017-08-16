#!/usr/bin/env bash
#title           : lico-update.sh
#description     : This is the official machine update script for the New Linux Counter Project (linuxcounter.net)
#license         : GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
#author          : Alexander Löhner <alex.loehner@linux.com>
#date            : 20150415
#version         : 0.0.4
#usage           : sh lico-update.sh
#notes           : grep, egrep, sed, awk, which and some more standard tools are needed to run this script
#bash_version    : GNU bash, Version 4.3.11(1)-release (x86_64-pc-linux-gnu)
#==============================================================================

lico_script_version="0.0.4"
lico_script_name="lico-update.sh"

apiurl="http://api.linuxcounter.net/v1"

#==============================================================================

export LANG=C
export PATH="${HOME}/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:${PATH}"

MYPATH=$(cd `dirname "${0}"` && pwd)/`basename "${0}"`

isBusyBox=$( [ $( find --help 2>&1 3>&1 4>&1 | head -n 1 | cut -d " " -f 1 ) = "BusyBox" ] && echo true || echo false )

if [ -x /bin/egrep ]; then
    EGREP="/bin/egrep"
elif [ -x /usr/bin/egrep ]; then
    EGREP="/usr/bin/egrep"
elif [ -x /usr/local/bin/egrep ]; then
    EGREP="/usr/local/bin/egrep"
fi

if [ -x /bin/grep ]; then
    GREP="/bin/grep"
elif [ -x /usr/bin/grep ]; then
    GREP="/usr/bin/grep"
elif [ -x /usr/local/bin/grep ]; then
    GREP="/usr/local/bin/grep"
fi

if [ -x /bin/head ]; then
    HEAD="/bin/head"
elif [ -x /usr/bin/head ]; then
    HEAD="/usr/bin/head"
elif [ -x /usr/local/bin/head ]; then
    HEAD="/usr/local/bin/head"
fi

if [ -x /bin/which ]; then
    WHICH="/bin/which"
elif [ -x /usr/bin/which ]; then
    WHICH="/usr/bin/which"
elif [ -x /usr/local/bin/which ]; then
    WHICH="/usr/local/bin/which"
fi

# Bins
WHICH=$( which which 2>/dev/null )
if [ "${WHICH}" = "" ]; then
    WHICH=$( type type 2>/dev/null | ${HEAD} -n 1 )
    if [ "${WHICH}" = "" ]; then
        WHICH=$( locate locate 2>/dev/null | ${EGREP} "bin/locate$" | ${HEAD} -n 1 )
        if [ "${WHICH}" = "" ]; then
            WHICH=$( find /usr/ -name find 2>/dev/null | ${EGREP} "bin/find$" | ${HEAD} -n 1 )
            if [ "${WHICH}" = "" ]; then
                echo "> No tool to locate the needed binaries found! I can not continue here!"
                exit 1
            else
                WHICH="${WHICH} / -name"
                HOW="find"
            fi
        else
            HOW="locate"
        fi
    else
        HOW="type"
    fi
else
    HOW="which"
fi

getBin() {
    binary="${1}"
    case "${HOW}" in
        "which")
            echo $( ${WHICH} ${binary} 2>/dev/null )
            ;;
        "type")
            # type is a shell builtin, so we don't have a path
            echo $( type -p ${binary} 2>/dev/null )
            ;;
        "locate")
            echo $( ${WHICH} ${binary} 2>/dev/null | ${EGREP} "bin/${binary}$" | ${GREP} -v proc | ${HEAD} -n 1 )
            ;;
        "find")
            for d in ${SPTH}; do
                f=$( ${WHICH} ${d} -name ${binary} | ${EGREP} "bin/${binary}$" | ${GREP} -v proc | ${HEAD} -n 1 )
                [[ ! "${f}" = "" ]] && break
            done
            echo "${f}"
            ;;
        *)
            echo $( ${WHICH} ${binary} 2>/dev/null )
            ;;
    esac
}

scriptJob() {
    s0=`echo ${SCRIPTNAME} | ${CUT} -d '.' -f 1`
    echo $s0
}

AT=$( getBin at 2>/dev/null )
AWK=$( getBin awk 2>/dev/null )
BASENAME=$( getBin basename 2>/dev/null )
CAT=$( getBin cat 2>/dev/null )
CRONTAB=$( getBin crontab 2>/dev/null )
CURL=$( getBin curl 2>/dev/null )
CUT=$( getBin cut 2>/dev/null )
DATE=$( getBin  date 2>/dev/null )
DF=$( getBin df 2>/dev/null )
DIFF=$( getBin diff 2>/dev/null )
DIRNAME=$( getBin dirname 2>/dev/null )
DMESG=$( getBin dmesg 2>/dev/null )
ECHO=$( getBin echo 2>/dev/null )
EGREP=$( getBin egrep 2>/dev/null )
FILE=$( getBin file 2>/dev/null )
FIND=$( getBin find 2>/dev/null )
GREP=$( getBin grep 2>/dev/null )
HEAD=$( getBin head 2>/dev/null )
ID=$( getBin id 2>/dev/null )
IFCONFIG=$( getBin ifconfig 2>/dev/null )
IWCONFIG=$( getBin iwconfig 2>/dev/null )
IP=$( getBin ip 2>/dev/null )
IOSTAT=$( getBin iostat 2>/dev/null )
KLDSTAT=$( getBin kldstat 2>/dev/null )
LAST=$( getBin last 2>/dev/null )
LASTLOG=$( getBin lastlog 2>/dev/null )
LASTLOGIN=$( getBin lastlogin 2>/dev/null )
LINKS=$( getBin links 2>/dev/null )
LS=$( getBin ls 2>/dev/null )
LSB_RELEASE=$( getBin lsb_release 2>/dev/null )
LSMOD=$( getBin lsmod 2>/dev/null )
MD5SUM=$( getBin md5sum 2>/dev/null )
NETCAT=$( getBin netcat 2>/dev/null )
if [[ "${NETCAT}" = "" ]]; then
    NETCAT=$( getBin nc 2>/dev/null )
fi
NETSTAT=$( getBin netstat 2>/dev/null )
OD=$( getBin od 2>/dev/null )
PS=$( getBin ps 2>/dev/null )
PERL=$( getBin perl 2>/dev/null )
RUNLEVEL=$( getBin runlevel 2>/dev/null )
SED=$( getBin sed 2>/dev/null )
SOCAT=$( getBin socat 2>/dev/null )
SORT=$( getBin sort 2>/dev/null )
SYSCTL=$( getBin sysctl 2>/dev/null )
TAIL=$( getBin tail 2>/dev/null )
TORSOCKS=$( getBin torsocks 2>/dev/null )
UNAME=$( getBin uname 2>/dev/null )
UNIQ=$( getBin uniq 2>/dev/null )
W=$( getBin w 2>/dev/null )
WC=$( getBin wc 2>/dev/null )
WGET=$( getBin wget 2>/dev/null )
WHOAMI=$( getBin whoami 2>/dev/null )
HOSTNAME=$( getBin hostname 2>/dev/null )
PING=$( getBin ping 2>/dev/null )
UPTIME=$( getBin uptime 2>/dev/null )
GETENT=$( getBin getent 2>/dev/null )

if [ "${HOME}" = "" ]; then
    if [ "${home}" = "" ]; then
        if [ "${WHOAMI}" != "" ]; then
            user=$( ${WHOAMI} )
            userhome="/home/${user}"
        else
            userhome="~"
        fi
    else
        userhome="${home}"
    fi
else
    userhome="${HOME}"
fi

export PATH="${userhome}/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
SPTH="${userhome}/bin /bin /usr/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin"
CONFDIR="${userhome}/.linuxcounter"
OLDCONFFILE="${CONFDIR}/config"
SPATH=$( pwd 2>/dev/null )
mypath="$( cd -P "$( ${DIRNAME} "$0" )" && pwd )"
SHADOW_FILE="/etc/shadow"
PASSWD_FILE="/etc/passwd"
LOGINDEFS_FILE="/etc/login.defs"
LSB_FILE="/etc/lsb-release"
myversion=${lico_script_version}
SCRIPTNAME=${lico_script_name}
SCRIPTJOB=$( scriptJob )
SCRIPT="${mypath}/${SCRIPTNAME}"

TMPDIR=""
if [ -w /tmp ]; then
    TMPDIR="/tmp"
elif [ -w /var/tmp ]; then
    TMPDIR="/var/tmp"
elif [ -w ${userhome}/tmp ]; then
    TMPDIR="${userhome}/tmp"
fi
if [ ! -d ${CONFDIR} ]; then
    mkdir -p ${CONFDIR}
fi
if [ "${TMPDIR}" = "" ]; then
    TMPDIR="${CONFDIR}/tmp"
    if [ ! -d ${TMPDIR} ]; then
        mkdir -p ${TMPDIR}
    fi
fi

if [ "${CRONTAB}" = "" ]; then
    CRONTAB=$( getBin fcrontab 2>/dev/null )
    if [ "${CRONTAB}" = "" ]; then
        echo "> No cron daemon found! Only cron or fcron are supported!"
        echo "> Automatic machine updates through cron would not be possible!"
    else
        USECRON="fcrontab"
    fi
else
    USECRON="crontab"
fi

releasefile=""
if [ -r /etc/os-release ]; then
    releasefile="/etc/os-release"
else
    if [ "${isBusyBox}" = "true" ]; then
        releasefile=$( ${FIND} /etc -type f -iname "*-release" 2>/dev/null | ${HEAD} -n 1 | ${GREP} -v lsb | ${GREP} -i -v strato )
    else
        releasefile=$( ${FIND} /etc -depth -mindepth 1 -maxdepth 1 -type f -iname "*-release" | ${GREP} -v lsb | ${GREP} -i -v strato )
    fi
    if [ "${releasefile}" = "" ]; then
        if [ "${isBusyBox}" = "true" ]; then
            releasefile=$( ${FIND} /etc -type f -iname "*version" 2>/dev/null | ${HEAD} -n 1 | ${GREP} -v lsb | ${GREP} -i -v strato )
        else
            releasefile=$( ${FIND} /etc -depth -mindepth 1 -maxdepth 1 -type f -iname "*version" )
        fi
    fi
fi

if [ "${UNAME}" = "" ]; then
    echo "> Program \"uname\" is needed to run this script!"
    exit 1
fi

OS=$( ${UNAME} )
if [ "${OS}" != "Linux" ]; then
    echo "This script actually supports only Linux!"
    exit 1
fi

if [ ! -r "${LSB_FILE}" -a "${LSB_RELEASE}" = "" -a "${releasefile}" = "" ]; then
    echo "> Program \"lsb_release\" is needed to run this script!"
    echo "  If this program is not available in your distribution repositories, then"
    echo "  Please create the file \"${LSB_FILE}\" with the following content:"
    echo "DISTRIB_ID=\"Your Distribution Name\""
    echo "DISTRIB_RELEASE=\"The version string of your distribution\""
    exit 1
fi
if [ "${GREP}" = "" ]; then
    echo "> Program \"grep\" is needed to run this script!"
    exit 1
fi
if [ "${CAT}" = "" ]; then
    echo "> Program \"cat\" is needed to run this script!"
    exit 1
fi
if [ "${HEAD}" = "" ]; then
    echo "> Program \"head\" is needed to run this script!"
    exit 1
fi
if [ "${TAIL}" = "" ]; then
    echo "> Program \"tail\" is needed to run this script!"
    exit 1
fi
if [ "${AWK}" = "" ]; then
    echo "> Program \"awk\" is needed to run this script!"
    exit 1
fi
if [ "${PING}" = "" ]; then
    echo "> Program \"ping\" is needed to run this script!"
    exit 1
fi
if [ "${SED}" = "" -a "${OS}" = "Linux" ]; then
    echo "> Program \"sed\" is needed to run this script!"
    exit 1
fi
if [ "${CURL}" = "" ]; then
    echo "> Program \"curl\" is needed to run this script!"
    exit 1
fi

if [ -z "${1}" ]; then
    echo " Usage:  ${SCRIPTNAME} [-i|-s|-m|-ci|-cu|-h|-v|-update]"
    echo " Use -h to get more help."
    exit 1
fi

if [ "${TORSOCKS}" != "" ]; then
    echo "> torsocks available, will proxy curl commands"
    CURL="$TORSOCKS $CURL"
fi

interactive=0
showdata=0
senddata=0
installcron=0
uninstallcron=0
showhelp=0
showversion=0
doupdate=0
wrongcmd=0
while [ $# -gt 0 ]
do
    case "x${1}x" in
        x-ix)           interactive=1;;
        x-sx)           showdata=1;;
        x-mx)           senddata=1;;
        x-cix)          installcron=1;;
        x-cux)          uninstallcron=1;;
        x-hx)           showhelp=1;;
        x-vx)           showversion=1;;
        x-updatex)      doupdate=1;;
        *)              wrongcmd=1;;
    esac
    shift
done

if [ ${wrongcmd} -eq 1 ]; then
    echo " Usage:  ${SCRIPTNAME} [-i|-s|-m|-ci|-cu|-h|-v|-update]"
    echo " Use -h to get more help."
    exit 1
fi

getDistribution(){
    if [ "${releasefile}" = "/etc/os-release" ]; then
        . /etc/os-release
        distribution=${NAME}
    else
        if [ "${LSB_RELEASE}" = "" ]; then
            if [ -r "${LSB_FILE}" ]; then
                . ${LSB_FILE}
                distribution="${DISTRIB_ID}"
            else
                release=""
                if [ "${releasefile}" = "" ]; then
                    if [ -d "/var/smoothwall" ]; then
                        distribution="Smoothwall Linux"
                    elif [ -n "$( getBin sorcery 2>/dev/null | ${GREP} -v ' ' )" -a -n "$( getBin gaze 2>/dev/null | ${GREP} -v ' ' )" ]; then
                        distribution="Source Mage Linux"
                    else
                        distribution=""
                    fi
                else
                    case "${releasefile}" in
                        /etc/gentoo-release)
                            distribution="Gentoo"
                            ;;
                        /var/ipcop/general-functions.pl)
                            distribution=`${GREP} 'version *=' ${releasefile} | ${HEAD} -n 1`
                            ;;
                        /etc/depmod.d/ubuntu.conf)
                            distribution="Ubuntu"
                            ;;
                        /etc/debian_version)
                            distribution="Debian GNU/Linux"
                            ;;
                        /etc/GoboLinuxVersion)
                            distribution="GoboLinux"
                            ;;
                        /etc/knoppix-version)
                            distribution="Knoppix"
                            ;;
                        /etc/zenwalk-version)
                            distribution="Zenwalk"
                            ;;
                        *)
                            distribution=$( ${CAT} ${releasefile} 2>/dev/null | ${HEAD} -n 1 )
                            ;;
                    esac
                fi
                if [ "${release}" = "" ] && [ "${distribution}" = "" ]; then
                    distribution=""
                elif [ "${distribution}" = "" ]; then
                    distribution=$( echo ${release} | ${AWK} '{print $1}' )
                fi
            fi
        else
            distribution=$(${LSB_RELEASE} -is)
        fi
    fi
    echo ${distribution}
}

getDistribVersion(){
    if [ "${LSB_RELEASE}" = "" ]; then
        if [ -r "${LSB_FILE}" ]; then
            . ${LSB_FILE}
            distribversion="${DISTRIB_RELEASE}"
        else
            release=""
            case "${releasefile}" in
                #            /etc/gentoo-release)
                #              if [ -h /etc/make.profile ]; then
                #                release=$( ${LS} -l /etc/make.profile 2>/dev/null | ${SED} -e 's;^.*/\([^/]*/[^/]*\)$;\1;' | tr '/' ' ' )
                #              else
                #                release=""
                #              fi
                #              ;;
                /var/ipcop/general-functions.pl)
                    release=$( ${GREP} 'version *=' ${releasefile} | ${HEAD} -n 1 )
                    ;;
                /etc/debian_version)
                    release=$( ${CAT} ${releasefile} )
                    ;;
                /etc/GoboLinuxVersion)
                    release=$( ${CAT} ${releasefile} )
                    ;;
                /etc/knoppix-version)
                    release=$( ${CAT} ${releasefile} )
                    ;;
                /etc/zenwalk-version)
                    release=$( ${CAT} ${releasefile} )
                    ;;
                /etc/os-release)
                    . /etc/os-release
                    release=${VERSION}
                    ;;
                *)
                    release=$( ${CAT} ${releasefile} 2>/dev/null | ${HEAD} -n 1 )
                    ;;
            esac
            if [ "${release}" = "" ]; then
                distribversion=""
            else
                distribversion=${release}
            fi
        fi
    else
        if [ "${releasefile}" = "/etc/os-release" ]; then
            . /etc/os-release
            distribversion=${VERSION}
        else
            distribversion=$(${LSB_RELEASE} -rs)
        fi
    fi
    echo ${distribversion}
}

# Displays OS name for example FreeBSD, Linux etc
getOs(){
    echo "$(${UNAME})"
}

# Display hostname
# host (FQDN hostname), for example, vivek (vivek.text.com)
getHostName(){
    # try 'hostname -f'
    myhostname=$(${HOSTNAME} -f 2>/dev/null || echo "")
    if [ "${OS}" = "Linux" ]; then
        if [ "${HOSTNAME}" = "" ]; then
            if [ -e /etc/hostname ] ; then
                myhostname=$( ${CAT} /etc/hostname 2>/dev/null )
            else
                myhostname=$( ${CAT} /proc/sys/kernel/hostname 2>/dev/null )
                mydomname=$( ${CAT} /proc/sys/kernel/domainname 2>/dev/null )
                if [ "${mydomname}" = "(none)" ]; then
                    mydomname="unknown-domain"
                fi
                myhostname=${myhostname}.${mydomname}
            fi
        else
            myhostname=$( ${HOSTNAME} )
        fi
    fi
    if [ "${myhostname}" = "" ]; then
        echo "The hostname of this machine couldn't be found."
        echo "Please install the \"inetutils\" (a.k.a. net-tools) package."
        exit 1
    else
        echo ${myhostname}
    fi
}

thishostname=$(getHostName)
CONFFILE="${CONFDIR}/${thishostname}"
if [ -r ${OLDCONFFILE} ]; then
    mv ${OLDCONFFILE} ${CONFFILE}
fi

if [ -r ${CONFFILE} ]; then
    . ${CONFFILE}
    if [ -z ${apikey+x} ]; then
        rm -fr ${CONFFILE}
        unset machine_id
    fi
fi

# Display CPU information such as Make, speed
getAccounts(){
    if [ "${OS}" = "Linux" ]; then
        UID_MIN=""
        UID_MAX=""
        if [ -r "${LOGINDEFS_FILE}" ]; then
            UID_MIN=$( ${EGREP} "^UID_MIN" ${LOGINDEFS_FILE} | ${AWK} '{print $2}' )
            UID_MAX=$( ${EGREP} "^UID_MAX" ${LOGINDEFS_FILE} | ${AWK} '{print $2}' )
        fi
        if [ "${UID_MIN}" = "" ]; then
            UID_MIN=1000
        fi
        if [ "${UID_MAX}" = "" ]; then
            UID_MAX=10000
        fi

        if [[ "${GETENT}" != "" ]]; then
            echo $(${GETENT} passwd 2>/dev/null | ${AWK} -F':' '{ if($3 >= '${UID_MIN}' && $3 <= '${UID_MAX}') print $0 }' | ${WC} -l)
        else
            echo $(${CAT} ${PASSWD_FILE} 2>/dev/null | ${AWK} -F':' '{ if($3 >= '${UID_MIN}' && $3 <= '${UID_MAX}') print $0 }' | ${WC} -l)
        fi
    fi
}

# Get CPU model name
getCpuInfo(){
    if [ "${distribution}" = "OpenWrt" ]; then
        [ "${OS}" = "Linux" ] && echo $(${GREP} -i "cpu model" /proc/cpuinfo | ${HEAD} -n 1 | ${SED} "s/.*: \(.*\)/\1/") || :
    else
        [ "${OS}" = "Linux" ] && echo $(${GREP} -i "model name" /proc/cpuinfo | ${HEAD} -n 1 | ${SED} "s/.*: \(.*\)/\1/") || :
    fi
}

# Get CPU MHz
getCpuFreq(){
    [ "${OS}" = "Linux" ] && echo $(${GREP} -i "cpu mhz" /proc/cpuinfo | ${HEAD} -n 1 | ${SED} "s/.*: \(.*\)/\1/") || :
}

# get CPU flags
getCpuFlags(){
    [ "${OS}" = "Linux" ] && echo $(${GREP} -i "flags" /proc/cpuinfo | ${HEAD} -n 1 | ${SED} "s/.*: \(.*\)/\1/") || :
}

# get CPU Cores
getNumCPUCores(){
    if [ "${distribution}" = "OpenWrt" ]; then
        [ "${OS}" = "Linux" ] && echo $(${GREP} -i "cpu model" /proc/cpuinfo | ${WC} -l) || :
    else
        [ "${OS}" = "Linux" ] && echo $(${GREP} -i "model name" /proc/cpuinfo | ${WC} -l) || :
    fi
}

# Display total RAM in system
getTotalRam(){
    mem=$( ${GREP} -i "memtotal" /proc/meminfo | ${HEAD} -n 1 | ${SED} "s/.*: *\(.*\) kB/\1/" )
    echo $(( ${mem} / 1000 ))
}

# Display free RAM in system
getFreeRam(){
    mem=$( ${GREP} -i "memfree" /proc/meminfo | ${HEAD} -n 1 | ${SED} "s/.*: *\(.*\) kB/\1/" )
    echo $(( ${mem} / 1000 ))
}

# Display total Swap in system
getTotalSwap(){
    mem=$( ${GREP} -i "swaptotal" /proc/meminfo | ${HEAD} -n 1 | ${SED} "s/.*: *\(.*\) kB/\1/" )
    echo $(( ${mem} / 1000 ))
}

# Display free Swap in system
getFreeSwap(){
    mem=$( ${GREP} -i "swapfree" /proc/meminfo | ${HEAD} -n 1 | ${SED} "s/.*: *\(.*\) kB/\1/" )
    echo $(( ${mem} / 1000 ))
}

# Display system load for last 5,10,15 minutes
getSystemLoad(){
    [ "${OS}" = "Linux" ] && echo "$(${UPTIME} | ${AWK} -F'load average: ' '{ print $2 }')" || :
}

# List total number of users logged in (both Linux and FreeBSD)
getNumberOfLoggedInUsers(){
    [ "${OS}" = "Linux" ] && echo "$(${W} -h | ${CUT} -d " " -f 1 | ${SORT} -u | ${WC} -l)" || :
}

getTotalDiskSpace() {
    if [ "${OS}" = "Linux" ]; then
        olddf=$( [ -z "$( ${DF} --help 2>&1 3>&1 4>&1 | ${GREP} -- "-l" )" ] && echo "1" || echo "0" )
        if [ "${olddf}" = "1" ]; then
            space=$( ${DF} 2>/dev/null | ${EGREP} "^/dev/" | ${SED} "s/  */\ /g" | ${CUT} -d " " -f 1-2 | ${SORT} | ${UNIQ} | ${CUT} -d " " -f 2 | ${AWK} '{s+=$1} END {printf "%d", s}' )
        else
            space=$( ${DF} -l -P 2>/dev/null | ${EGREP} "^/dev/" | ${SED} "s/  */\ /g" | ${CUT} -d " " -f 1-2 | ${SORT} | ${UNIQ} | ${CUT} -d " " -f 2 | ${AWK} '{s+=$1} END {printf "%d", s}' )
        fi
        echo $(( ${space} / 1000 ))
    fi
}

getFreeDiskSpace() {
    if [ "${OS}" = "Linux" ]; then
        olddf=$( [ -z "$( ${DF} --help 2>&1 3>&1 4>&1 | ${GREP} -- "-l" )" ] && echo "1" || echo "0" )
        if [ "${olddf}" = "1" ]; then
            space=$( ${DF} 2>/dev/null | ${EGREP} "^/dev/" | ${SED} "s/  */\ /g" | ${CUT} -d " " -f 1-4 | ${SORT} | ${UNIQ} | ${CUT} -d " " -f 4 | ${AWK} '{s+=$1} END {printf "%d", s}' )
        else
            space=$( ${DF} -l -P 2>/dev/null | ${EGREP} "^/dev/" | ${SED} "s/  */\ /g" | ${CUT} -d " " -f 1-4 | ${SORT} | ${UNIQ} | ${CUT} -d " " -f 4 | ${AWK} '{s+=$1} END {printf "%d", s}' )
        fi
        echo $(( ${space} / 1000 ))
    fi
}

getUptime() {
    if [ "${OS}" = "Linux" ]; then
        if [ -r /proc/uptime ]; then
            uptime=$( ${CUT} -d "." -f 1 /proc/uptime )
        fi
        echo ${uptime}
    fi
}

getOnlineStatus() {
    if [ "${OS}" = "Linux" ]; then
        pingstatus=$( ${PING} -q -c 1 linuxcounter.net 2>&1 | ${GREP} -i packet | ${CUT} -d " " -f 1 )
        [ "${pingstatus}" = "" ] && echo "0"
        [ "${pingstatus}" -gt 0 ] && echo "1"
    fi
}

getNetwork(){
    if [ "${OS}" = "Linux" ]; then
        wlan=$( ${IWCONFIG} 2>/dev/null | ${GREP} -i essid )
        if [ "${wlan}" != "" ]; then
            network="wireless"
        else
            network="ethernet"
        fi
        echo ${network}
    fi
}

# Encode argument as application/x-www-form-urlencoded
urlEncode(){
    echo "${1}" | ${AWK} '
    BEGIN { RS = sprintf("%c", 0) }  # operate on whole text including newlines
    { gsub(/%/,"%25")
      for (i = 1; i < 10; ++i) gsub(sprintf("%c", i),"%" sprintf("%.2X", i) )
      gsub(/\013/,"%0B"); gsub(/\014/,"%0C")
      for (i = 14; i < 32; ++i) gsub(sprintf("%c", i),"%" sprintf("%.2X", i) )
      gsub(/\041/,"%21"); gsub(/\042/,"%22"); gsub(/\043/,"%23")
      gsub(/\$/,"%24");   gsub(/\046/,"%26"); gsub(/\047/,"%27")
      gsub(/\(/,"%28");   gsub(/\)/,"%29");   gsub(/\*/,"%2A")
      gsub(/\+/,"%2B");   gsub(/\054/,"%2C"); gsub(/\057/,"%2F")
      gsub(/\072/,"%3A"); gsub(/\073/,"%3B"); gsub(/\074/,"%3C")
      gsub(/\075/,"%3D"); gsub(/\076/,"%3E"); gsub(/\?/,"%3F")
      gsub(/\100/,"%40"); gsub(/\[/,"%5B");   gsub(/\\/,"%5C")
      gsub(/\135/,"%5D"); gsub(/\^/,"%5E");   gsub(/\140/,"%60")
      gsub(/\{/,"%7B");   gsub(/\|/,"%7C");   gsub(/\175/,"%7D")
      for (i = 126; i < 256; ++i) gsub(sprintf("%c", i),"%" sprintf("%.2X", i) )
      gsub(/\040/,"+");   gsub(/\012/,"%0D%0A")  # convert LF to CR LF
      gsub(/\015%0D/,"%0D")  # do not double CR when already part of CR LF
      gsub(/\015/,"%0D"); sub(/%0D%0A$/,"")      # remove trailing CR LF
      print } '
}

parse_json(){
    echo "$1" | \
        sed "s/:\([0-9]\)/:\"\1/g" | \
        sed "s/\([0-9]\),\"/\1\",\"/g" | \
        sed "s/\([0-9]\)\}/\1\"}/g" | \
        sed -e 's/[{}]/''/g' | \
        sed -e 's/", "/'\",\"'/g' | \
        sed -e 's/" ,"/'\",\"'/g' | \
        sed -e 's/" , "/'\",\"'/g' | \
        sed -e 's/","/'\"---SEPERATOR---\"'/g' | \
        awk -F=':' -v RS='---SEPERATOR---' "\$1~/\"$2\"/ {print}" | \
        sed -e "s/\"$2\"://" | \
        tr -d "\n\t" | \
        sed -e 's/\\"/"/g' | \
        sed -e 's/\\\\/\\/g' | \
        sed -e 's/^[ \t]*//g' | \
        sed -e 's/^"//'  -e 's/"$//'
}

scanSystem(){
    script=${scriptversion}
    hostname=$(getHostName)
    distribution=$(getDistribution)
    distversion=$(getDistribVersion)
    version=$(${UNAME} -r)
    machine=$(${UNAME} -m)
    processor=$(getCpuInfo)
    cpunum=$(getNumCPUCores)
    flags=$(getCpuFlags)
    totalram=$(getTotalRam)
    freeram=$(getFreeRam)
    totalswap=$(getTotalSwap)
    freeswap=$(getFreeSwap)
    load=$(getSystemLoad)
    date=$(${DATE})
    numusers=$(getNumberOfLoggedInUsers)
    accounts=$(getAccounts)
    totaldisk=$(getTotalDiskSpace)
    freedisk=$(getFreeDiskSpace)
    uptime=$(getUptime)
    cpufreq=$(getCpuFreq)
    update_key=""
    network=$(getNetwork)
    online=$(getOnlineStatus)
    echo "apikey=\"${apikey}\"" > ${CONFFILE}
    echo "machine_id=\"${machine_id}\"" >> ${CONFFILE}
    echo "machine_updatekey=\"${machine_updatekey}\"" >> ${CONFFILE}
    echo "hostname=\"${hostname}\"" >> ${CONFFILE}
    echo "distribution=\"${distribution}\"" >> ${CONFFILE}
    echo "distversion=\"${distversion}\"" >> ${CONFFILE}
    echo "kernel=\"${version}\"" >> ${CONFFILE}
    echo "architecture=\"${machine}\"" >> ${CONFFILE}
    echo "cpu=\"${processor}\"" >> ${CONFFILE}
    echo "cores=\"${cpunum}\"" >> ${CONFFILE}
    echo "flags=\"${flags}\"" >> ${CONFFILE}
    echo "memory=\"${totalram}\"" >> ${CONFFILE}
    echo "memoryFree=\"${freeram}\"" >> ${CONFFILE}
    echo "swap=\"${totalswap}\"" >> ${CONFFILE}
    echo "swapFree=\"${freeswap}\"" >> ${CONFFILE}
    echo "loadavg=\"${load}\"" >> ${CONFFILE}
    echo "accounts=\"${accounts}\"" >> ${CONFFILE}
    echo "diskspace=\"${totaldisk}\"" >> ${CONFFILE}
    echo "diskspaceFree=\"${freedisk}\"" >> ${CONFFILE}
    echo "uptime=\"${uptime}\"" >> ${CONFFILE}
    echo "network=\"${network}\"" >> ${CONFFILE}
    echo "online=\"${online}\"" >> ${CONFFILE}
}

sendDataToApi(){
    . ${CONFFILE}
    echo "> Sending the data to your machine in your account using the API..."
    if [ -z ${apikey+x} ] || [ "${apikey}" = "" ]; then
        echo "! ApiKey is not set! Please run the script with \"-i\"!"
        exit 1
    fi
    if [ -z ${machine_id+x} ] || [ "${machine_id}" = "" ]; then
        echo "! machine_id is not set! Please run the script with \"-i\" and choose [1]!"
        exit 1
    fi
    if [ -z ${machine_updatekey+x} ] || [ "${machine_updatekey}" = "" ]; then
        echo "! machine_updatekey is not set! Please run the script with \"-i\" and choose [1]!"
        exit 1
    fi
    scanSystem
    . ${CONFFILE}
    if [ "${httpproxy}" != "" ]; then
        PROXY="--proxy ${httpproxy}"
    fi
    ${CURL} -s --request PATCH ${PROXY} \
        "${apiurl}/machines/${machine_id}" \
        --header "x-lico-machine-updatekey: ${machine_updatekey}" \
        --data "hostname=${hostname}" \
        --data "distribution=${distribution}" \
        --data "distversion=${distversion}" \
        --data "kernel=${kernel}" \
        --data "architecture=${architecture}" \
        --data "cpu=${cpu}" \
        --data "cores=${cores}" \
        --data "flags=${flags}" \
        --data "memory=${memory}" \
        --data "memoryFree=${memoryFree}" \
        --data "swap=${swap}" \
        --data "swapFree=${swapFree}" \
        --data "loadavg=${loadavg}" \
        --data "accounts=${accounts}" \
        --data "diskspace=${diskspace}" \
        --data "diskspaceFree=${diskspaceFree}" \
        --data "uptime=${uptime}" \
        --data "network=${network}" \
        --data "online=${online}"
    echo "> Data successfully sent."
}

installCronjob(){
    echo "> Installing the weekly cronjob..."
    ${CRONTAB} -l > ${TMPDIR}/crontab.tmp
    isset=$( ${GREP} "${SCRIPTJOB}" ${TMPDIR}/crontab.tmp )
    if [ "${isset}" != "" ]; then
        echo "! The cronjob already is active!"
        exit 1
    else
        min=$((`${CAT} /dev/urandom | ${OD} -N1 -An -i` % 59))
        hour=$((`${CAT} /dev/urandom | ${OD} -N1 -An -i` % 23))
        dow=$((`${CAT} /dev/urandom | ${OD} -N1 -An -i` % 7))
        echo "# added by ${lico_script_name} ${lico_script_version}" >> ${TMPDIR}/crontab.tmp
        echo "${min} ${hour} * * ${dow} ${SCRIPT} -m >/dev/null 2>&1" >> ${TMPDIR}/crontab.tmp
        ${CRONTAB} ${TMPDIR}/crontab.tmp
        rm ${TMPDIR}/crontab.tmp
        echo "> The cronjob got successfully activated!"
    fi
}

uninstallCronjob(){
    echo "> UNinstalling the weekly cronjob..."
    ${CRONTAB} -l > ${TMPDIR}/crontab.tmp
    isset=$( ${GREP} "${SCRIPTJOB}" ${TMPDIR}/crontab.tmp )
    if [ "${isset}" = "" ]; then
        echo "! The cronjob is not active!"
        exit 1
    else
        ${SED} -e "/${SCRIPTJOB}/d" -e "/${lico_script_version}/d" -i ${TMPDIR}/crontab.tmp
        ${CRONTAB} ${TMPDIR}/crontab.tmp
        status=$?
        rm ${TMPDIR}/crontab.tmp
        if [ ${status} -ne 0 ]; then
            echo "! cron encountered a problem and exited with status ${status}"
            exit ${status}
        fi
        echo "> The cronjob was successfully removed!"
    fi
}

updateScript(){
    whoami=$( whoami )
    ${WGET} -O /tmp/lico-update.sh 'https://raw.githubusercontent.com/alexloehner/linuxcounter-update-examples/master/_official/lico-update.sh'
    if [ "${whoami}" = "root" ]; then
        mv /tmp/lico-update.sh ${MYPATH}
        chmod +x ${MYPATH}
    else
        sudo mv /tmp/lico-update.sh ${MYPATH}
        sudo chmod +x ${MYPATH}
    fi
}

# Require working configuration for commands which need it
if [ -z ${machine_id+x} ]; then
    if [[ ${installcron} -eq 1 ]] || [[ ${showdata} -eq 1 ]] || [[ ${senddata} -eq 1 ]]; then
        echo "Configuration is missing or incomplete!"
        echo "Please run \"${SCRIPTNAME} -i\" first and register this machine."
        exit 1
    fi
fi

if [ ${showhelp} -eq 1 ]; then
    echo ""
    echo " Usage:  ${SCRIPTNAME} [-i|-s|-m|-ci|-cu|-h|-v|-update]"
    echo ""
    echo "   -i           Use this switch to enter interactive mode. The script will"
    echo "                then ask you a few questions related your counter"
    echo "                membership. Your entered data will be stored in"
    echo "                ${CONFFILE}"
    echo ""
    echo "   -s           This will show you what will be sent to the counter, without"
    echo "                sending anything."
    echo ""
    echo "   -m           Use this switch to let the script send the collected data"
    echo "                to the counter project. If the machine entry does not exist,"
    echo "                the script will exit with code 1."
    echo ""
    echo "   -ci          Use this switch to automatically create a cronjob (or at job)"
    echo "                for this script. The data will then get sent once per week."
    echo ""
    echo "   -cu          Use this to uninstall the cronjob (or at job)"
    echo ""
    echo "   -h           Well, you've just used that switch, no?"
    echo "   -v           This gives you the version of this script"
    echo ""
    echo "   -update      Get and install the most recent version of this script (may need sudo!)"
    echo ""
    echo " More information here:  https://www.linuxcounter.net/download"
    echo ""
fi
if [ ${showversion} -eq 1 ]; then
    echo ""
    echo " ${lico_script_version}"
    echo ""
fi
if [ ${installcron} -eq 1 ]; then
    installCronjob
fi
if [ ${uninstallcron} -eq 1 ]; then
    uninstallCronjob
fi
if [ ${doupdate} -eq 1 ]; then
    updateScript
fi
if [ ${showdata} -eq 1 ]; then
    echo "> Showing the current configuration and exiting..."
    echo ""
    echo "### config start"
    cat ${CONFFILE}
    echo "### config end"
    echo ""
    exit 0
fi
if [ ${senddata} -eq 1 ]; then
    sendDataToApi
fi

if [ ${interactive} -eq 1 ]; then
    echo "> Entering interactive mode..."
    echo ""
    if [ -z ${apikey+x} ]; then
        echo "> Please enter your ApiKey for your linuxcounter.net account."
        echo "> You can find this Key when logging in to your account and then visiting your profile:"
        echo "> https://www.linuxcounter.net/profile/"
        echo ""
        echo -n "> "
        read apikey
        echo "apikey=\"${apikey}\"" >> ${CONFFILE}
        echo ""
    fi
    echo "> What do you want to do? Please choose a number:"
    echo ""
    echo "  [1] Create a new machine in your linuxcounter account. This should only be done, if this machine is not already stored in your linuxcounter account."
    echo "  [2] Show the current configuration on stdout"
    echo "  [3] Rescan the system and replace the current configuration with the scanned data"
    echo "  [4] Use the current configuration and send it to the linuxcounter"
    echo "  [5] Install the weekly cronjob for automatic sending of the machine data"
    echo "  [6] UNinstall the weekly cronjob"
    echo "  [7] Get the newest version of this script (may require sudo!)"
    echo ""
    echo -n ">  "
    read interactive_action
    echo ""

    if [ ${interactive_action} -eq 1 ]; then
        if [ "${machine_id}" != "" ]; then
            echo "! This machine already has a configuration and a machine_id"
            echo "! Have you maybe created this machine already in your account?"
            echo "! If you are sure, that you want to create a new machine in your account for this machine, then please delete the file ${CONFFILE} and rerun the script."
            exit 1
        fi
        echo "> Sending \"create machine\" request to the API..."
        response=$( ${CURL} -s --request POST "${apiurl}/machines" --header "x-lico-apikey: ${apikey}" )
        machine_id=$( parse_json "${response}" machine_id )
        machine_updatekey=$( parse_json "${response}" machine_updatekey )
        echo "machine_id=\"${machine_id}\"" >> ${CONFFILE}
        echo "machine_updatekey=\"${machine_updatekey}\"" >> ${CONFFILE}
        echo "> Machine created and machine information stored in configuration."
        echo "> Now you may want to fill your machine with some data (\"${SCRIPTNAME} -i\" and then choose [3])"
        echo ""
    fi

    if [ ${interactive_action} -eq 2 ]; then
        echo "> Showing the current configuration and exiting..."
        echo ""
        echo "### config start"
        cat ${CONFFILE}
        echo "### config end"
        echo ""
        exit 0
    fi

    if [ ${interactive_action} -eq 3 ]; then
        echo "> Scanning this system..."
        echo ""
        scanSystem
        echo "### config start"
        cat ${CONFFILE}
        echo "### config end"
        echo ""
        exit 0
    fi

    if [ ${interactive_action} -eq 4 ]; then
        sendDataToApi
    fi

    if [ ${interactive_action} -eq 5 ]; then
        if [ "${machine_id}" != "" ]; then
            installCronjob
        else
            echo "! Machine ID is unknown."
            echo "! Please register this machine first. (\"${SCRIPTNAME} -i\" and then choose [1])"
            echo ""
            exit 1
        fi
    fi

    if [ ${interactive_action} -eq 6 ]; then
        uninstallCronjob
    fi

    if [ ${interactive_action} -eq 7 ]; then
        updateScript
    fi
fi

#eof
