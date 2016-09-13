#!/usr/bin/perl -w
#
my %outside=();
open LOG," ) {
($ext)=/outside:(\S+)\//;
if ( ! exists $outside{$ext} ) {
$outside{$ext}=1;			# add to hash
 } else {
$outside{$ext}++;			# increment connection counter
  }
}
 # look through list of hostile IP addresses to see if any have been seen in log
     while (  ) {
     chomp;
    if ( exists $outside{$_} ) {
    print "FOUND: $_ $outside{$_} time(s)\n";
   }
}
