#! /usr/bin/perl -w
#
#  check_redis_cc.pl
#  by Zach Armstrong
###########################
# Modified by Sailesh Kumar to check additional parameters
# on 05/12/2011
##########################
#  This nagios check checks redis connected_clients and 
#  alerts when exceeding the given warn/crit values
#
#
# Copyright (c) 2010 Zachary Armstrong
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# alon with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#
# 0 = ok
# 1 = warn
# 2 = crit
# 3 = unknown

#configurable options:
my $debug = 0;

# No changes below, unless you want to change exit codes
use lib "/usr/local/nagios/libexec" ;
use Getopt::Std;
use strict;
use warnings;
use utils qw( %ERRORS);
my $VERSION = '0.1';

%ERRORS=('OK'=>0,'WARNING'=>1,'CRITICAL'=>2,'UNKNOWN'=>3);

my %options=();

getopts("H:p:s:w:c:W:C:", \%options);

if (scalar(keys(%options))<6 ){
	print "\n\n";
        print "usage: -H hostname -p port -s String -w warnValMin -c critValMin -W warnValMax -C critValMax \n";
	print "\n -p port - default is 6379 \n";
	print "\n Min vals will trigger the alert upon going under that amount\n";
	print "\n Max vals will trigger the alert upon going over that amount\n";
	print "\n String can be connections, memory, uptime or slave\n";

	show_options();

        exit  $ERRORS{'UNKNOWN'}; # This will register as unknown in nagios
}

my $i=0;
my $exit_value = $ERRORS{'UNKNOWN'} ;
my $return_val =0;
my $retval;
my $stat =" ";

my $myHost=$options{'H'};
my $myPort=$options{'p'};
my $myString=$options{'s'};

my $warnValMin=$options{'w'};
my $critValMin=$options{'c'};
my $warnValMax=$options{'W'};
my $critValMax=$options{'C'};

# Get number of connections
if ($myString =~ /^connections$/i) {
my $cmd = "/aeappdir/local_bin/redis-cli -h $myHost -p $myPort info|grep connected_clients |awk -F\\: {'print \$2'}";
$retval = `$cmd`;
$retval=~ s/\s+$//;
$stat = "Connected_clients :";
}
# Get memory usage
elsif ($myString =~ /^memory$/i) {
my $cmd = "/aeappdir/local_bin/redis-cli -h $myHost -p $myPort info|grep used_memory_human |awk -F\\: {'print \$2'}|sed 's/G//'";
$retval = `$cmd`;
$retval=~ s/\s+$//;
$stat = "Used_memory in GB :";
}
# Get uptime
elsif ($myString =~ /^uptime$/i) {
my $cmd = "/aeappdir/local_bin/redis-cli -h $myHost -p $myPort info|grep uptime_in_seconds |awk -F\\: {'print \$2'}";
$retval = int(`$cmd` / 3600);
$retval=~ s/\s+$//;
$stat = "Uptime_in_hours :";
}
# Get connected slaves
elsif ($myString =~ /^slave$/i) {
my $cmd = "/aeappdir/local_bin/redis-cli -h $myHost -p $myPort info|grep connected_slaves |awk -F\\: {'print \$2'}";
$retval = `$cmd`;
$retval=~ s/\s+$//;
$stat = "Connected_slaves :";
}
# Set state to Unknown for anything else
else {
     $stat = "Unknown string to test";
     print "\n $stat exting... \n";	
     print "String (-s) can be connections, memory, uptime or slave\n";
     exit  $ERRORS{'UNKNOWN'};
}

if ($debug)
{
  print "Count: $retval --";
}  

#$clients = $retval~ s/\n/ /;
  
if (($retval < $critValMin))
{
	$exit_value = $ERRORS{'CRITICAL'};
} 
elsif (($retval < $warnValMin))
{
	$exit_value = $ERRORS{'WARNING'};
}
elsif (($retval > $critValMax))
{
	$exit_value = $ERRORS{'CRITICAL'};
}
elsif (($retval > $warnValMax))
{
	$exit_value = $ERRORS{'WARNING'};
}	
elsif (($retval < $warnValMax) && ($retval > $warnValMin))
{
	$exit_value = $ERRORS{'OK'};
}

my $exit_value_human="";

if ($exit_value == 0)
{
  $exit_value_human="OK";    
}
elsif ($exit_value == 1)
{
  $exit_value_human="WARNING";    
}
elsif ($exit_value == 2)
{
  $exit_value_human="CRITICAL";    
}
elsif ($exit_value == 3)
{
  $exit_value_human="UNKNOWN";    
}

print "$stat $retval  STATUS: $exit_value_human\n";
exit $exit_value;
		
		
sub show_options {

print "-H $options{H} " if defined $options{H};
print "-p $options{p} " if defined $options{p};
print "-s $options{s} " if defined $options{s};
print "-w $options{w} " if defined $options{w};
print "-c $options{c} " if defined $options{c};
print "-W $options{W} " if defined $options{W};
print "-C $options{C} " if defined $options{C};

# print "Unprocessed by Getopt::Std:\n" if $ARGV[0];
foreach (@ARGV) {
  print "$_";
}
print  "\n\n";
}			
		
# redis-cli info|grep connected_clients |awk -F\\: {'print $2'}

