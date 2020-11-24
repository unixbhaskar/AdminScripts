#
# This file is read each time a login shell is started.
# All other interactive shells will only read .bashrc; this is particularly
# important for language settings, see below.

test -z "$PROFILEREAD" && . /etc/profile || true

if [ -n "$BASH" ] && [ -r ~/.bashrc ]; then
    . ~/.bashrc
fi

if [[ "$(tty)" = "/dev/tty1" ]]; then
	/usr/local/bin/check_init
fi
if [[ "$(tty)" = "/dev/tty2" ]]; then
	    pgrep i3 || i3_start
fi



# Most applications support several languages for their output.
# To make use of this feature, simply uncomment one of the lines below or
# add your own one (see /usr/share/locale/locale.alias for more codes)
# This overwrites the system default set in /etc/sysconfig/language
# in the variable RC_LANG.
#
#export LANG=de_DE.UTF-8	# uncomment this line for German output
#export LANG=fr_FR.UTF-8	# uncomment this line for French output
#export LANG=es_ES.UTF-8	# uncomment this line for Spanish output


# Some people don't like fortune. If you uncomment the following lines,
# you will have a fortune each time you log in ;-)

#if [ -x /usr/bin/fortune ] ; then
#    echo
#    /usr/bin/fortune
#    echo
#fi

export PATH="$PATH:/home/bhaskar/bin"
export NSPR_LOG_MODULES=nsHttp:3,nsHostResolver:3,timestamp,rotate:200,nsHttp:5,cache2:5,nsSocketTransport:5,nsHostResolver:5,sync
export MOZ_LOG=nsHttp:3,nsHostResolver:3,timestamp,rotate:200,nsHttp:5,cache2:5,nsSocketTransport:5,nsHostResolver:5,sync
export NSPR_LOG_FILE=/data/firefox_log/firefox.log-main.16526.moz_log
export MOZ_LOG_FILE=/data/firefox_log/firefox.log-main.16526.moz_log
