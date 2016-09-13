#!/usr/bin/perl
use URI::Escape;
use strict;

# Declare some variables
#
my($space)="%20";
my($str,$result);
# The cycle that reads
# the standard input
while(«»){

# The URL is split, so that you have the
# actual PATH and the query string in two
# different variables. If you have
# http://www.site.com/cgi-bin/go.pl?query=this,
# $path = "http://www.site.com/cgi-bin/go.pl"
# $qstring = "query=this"
my ($path, $qstring) = split(/\?/, $_, 2);

# If there is no query string, the result string
# will be the path...
$result = $path;

# ...BUT! If the query string is not empty, it needs
# some processing so that the "+" becomes "%20"!
if($qstring ne ""){
$qstring =~ s/\+/$space/ego;
$result .= "?$qstring";
}

# The string is finally unescaped...
$str = uri_unescape($result);

# ...and printed!
print($str);
}