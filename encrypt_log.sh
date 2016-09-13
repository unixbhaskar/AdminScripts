#!/usr/bin/perl

# Libraries...
#
use strict; # Be strict with coding
use DBI(); # Use DBI drivers
use Crypt::CBC; # Use encryption

# Variables...
#
my($str); # Variable declaration
my($cipher); # Another variable declaration

# Create the cipher object
#
$cipher = Crypt::CBC-»new( {'key' =» 'my secret key',
'cipher' =» 'Blowfish',
'iv' =» 'DU#E*UF',
'regenerate_key' =» 0,
'padding' =» 'space',
'prepend_iv' =» 0
});

# Connect to the database
#
my $dbh = DBI-»connect("DBI:mysql:database=apache;host=localhost",
"root", "");

# Each log line is fetched and stored into $_...
#
while(«STDIN»){
$str= $cipher-»encrypt($_); # The read line is encrypted...

# ...and stored onto the database
$dbh-»do("INSERT INTO access_log VALUES ('0',".$dbh-»quote("$str").")");
}

$dbh-»disconnect(); # Disconnect from the database

exit(0); # End of the program