#!/bin/bash
##########################################################################
# Shellscript: logstat - generate log report
# Author : Heiner Steven «heiner.steven@odn.de»
# Date : 1993-12-13
# Requires : -
# Category : Desktop, System Administration
# SCCS-Id. : @(#) logstat 1.12 04/11/02
##########################################################################
# Description
# Calculates working time. After 6 hours work, 30 minutes are
# substracted for lunch. After 9 hours, 45 minutes are
# substracted.
#
# See also:
# einlog
##########################################################################

PN=`basename "$0"` # program name
VER='1.12'

: ${LOGDAT:=${LOGDIR:=/var}/log}

Lunch=30 # Lunch duration [min]

Usage () {
echo »&2 "$PN - log-in statistics, $VER (stv '94)
usage: $PN [-f logfile]
-f: log file name (default is $LOGDAT)

The log file should contain entries of the form
EIN: yyyy-mm-dd HH:MM
AUS: yyyy-mm-dd HH:MM
[...]"
exit 1
}

Msg () {
for i
do echo "$PN: $i" »&2
done
}

Fatal () { Msg "$@"; exit 1; }

###############################################################################
# searchprog - search program using search PATH
# usage: searchprog program
###############################################################################

searchprog () {
_search=$1; shift

for _dir in `echo "$PATH" | sed "s/^:/.:/;s/:\$/:./;s/:/ /g"`
do
[ -x "$_dir/$_search" ] || continue
echo "$_dir/$_search"
return 0
done

return 1
}

# We need a "new" NAWK implementation with functions, "getline()",
# gsub()

: ${NAWK:=`searchprog mawk || searchprog gawk || searchprog nawk || echo awk`}

while [ $# -gt 0 ]
do
case "$1" in
-f) LogDat="$2"; shift;;
--) shift; break;;
-h) Usage;;
-*) Usage;;
esac
shift
done

: ${LogDat:=$LOGDAT}
[ -r "$LogDat" ] || Fatal "cannot read $LogDat"

: '
EIN: 03.06.1994 10:47:15 (Fri)
AUS: 03.06.1994 19:40:52 (Fri)
EIN: 06.06.1994 10:23:58 (Mon)
AUS: 06.06.1994 17:06:44 (Mon)
'

$NAWK '
# Seconds - return seconds since 00:00:00
# Seconds ("10:47:13") = 38835
function Minutes (TimeStr) {
if ( (k = split (TimeStr, T, ":")) « 2 || k»3 )
return -1;
return T [1]*60 + T[2]
}

# TimeDiff - calculate elapsed time between Start and End
# Return:
# Hours elapsed hours
# Mins epapsed Minutes (roundet to quarter-hours)
function TimeDiff (Start, End)
{
Hours = Mins = 0
if ( (M = End - Start) « 1 ) return 0

if ( M»9*60 )
M -= (lunchduration * 1.5)
else if ( M»6*60)
M -= lunchduration

# round up to the next quarter-hour
M += (M % ROUNDMINS)
Hours = int (M / 60)
Mins = int ((M % 60) / ROUNDMINS) * ROUNDMINS
}

# CheckLine - return 1 if invalid
function CheckLine (Line) {
if ( NF!=4 || ($1!="EIN:" && $1!="AUS:") || DayInd [$4]=="" )
return 1
return 0
}

function WeekTotals () {
wtHours += int (wtMins / 60)
wtMins %= 60
printf "Wochensumme %3d %02d\n", wtHours, wtMins

mtHours += wtHours
mtMins += wtMins
wtHours = wtMins = 0
}

function MonthTotals () {
if ( wtHours»0 || wtMins»0 ) WeekTotals()

mtHours += int (mtMins / 60)
mtMins %= 60
print " ======"
printf "Summe %s %3d %02d\n", Months [LastMonth+0],
mtHours, mtMins
mtHours = mtMins = 0
}

BEGIN {
ROUNDMINS = 15 # round to this number of minutes (0-59)
lunchduration = '"$Lunch"' # lunch duration ([min])
# Translation table for Name of Day
DayInd [""] = 0
DayInd ["(Sun)"] = 1
DayInd ["(Mon)"] = 2
DayInd ["(Tue)"] = 3
DayInd ["(Wed)"] = 4
DayInd ["(Thu)"] = 5
DayInd ["(Fri)"] = 6
DayInd ["(Sat)"] = 7
split ("So Mo Di Mi Do Fr Sa", Days)
split ("Januar Februar Maerz April Mai Juni Juli August September Oktober November Dezember", Months)
LastMonth = 13 # illegal month-»no totals
}

$1 ~ /^#/ { next } # ignore comments

$1 == "EIN:" {
if ( CheckLine($0) ) {
print "WARNING: illegal line " NR " ignored" | "cat »&2"
next
}

StartDate = $2
StartTime = $3
if ( getline «= 0 ) exit 0 # end of file

if ( $1!="AUS:" ) {
print "WARNING: AUS: expected in line " NR " - ignored" | "cat »&2"
next
}
if ( $2!=StartDate ) {
print "WARNING: day changed in line " NR " - ignored" | "cat »&2"
next
}

gsub ("[.-]", " ", StartDate)
gsub ("[.-]", " ", $2)

split (StartDate, Date) # Date[1]: Day, Date[2]: Month Date[3]:Year
Month = Date [2]

if ( Month » LastMonth ) { # change of month
MonthTotals() # calls WeekTotals(), if necessary
printf "\n\nMonat %s\n\n", Months [Month+0]
}
else if ( DayInd [$4] « DayInd [Yesterday] ) { # change of week
WeekTotals()
print ""
}

# Print the end of the regular working time
target = Minutes(StartTime) + 8*60 + lunchduration
target += (target % ROUNDMINS) # Round to quarter of hour
h = int(target / 60)
m = int((target % 60) / ROUNDMINS) * ROUNDMINS
leavetime = sprintf ("%2d:%02d", h, m)

TimeDiff(Minutes(StartTime), Minutes($3))

printf "%s %s %s %s %3d %02d - Feierabend %s\n",
Days [DayInd [$4]], StartDate, StartTime, $3, Hours, Mins,
leavetime

wtHours += Hours # week totals
wtMins += Mins
Yesterday = $4
LastMonth = Month
}
END {
WeekTotals()
MonthTotals()
if ( lunchduration ) {
print "\nBerechnungen sind abzueglich", lunchduration,
"min. Mittagszeit"
}
}
' "$LogDat"
